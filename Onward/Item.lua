-- Quest item buttons: on a step whose quest has you use an item (fletch the Wood Bundles, throw
-- the spear at a crocolisk, read the satchel), a button that uses it, next to the target button.
-- When the quests you're working on together need several items, one button each (up to four),
-- the current step's first. Bind keys under Key Bindings > AddOns > Onward.
--
-- Which items: the one the guide names (|item <id>, the item the quest gives you), and usable
-- quest items in your bags that the quest's own text names ("Collect Wood Bundles ..."). Only
-- items you have and that have a Use: effect count.
--
-- Like the target button these are SecureActionButtons: their items and positions change only out
-- of combat, and a change in combat waits for combat to end.
local _, W = ...
local IT = {}
W.Item = IT

local G, QS = W.Guide, W.QuestState
local SIZE, BIG, GAP = 22, 40, 2
local MAX = 4

local buttons = {}
local pending = false
IT.items = {}         -- item ids on the buttons, in order
IT.item = nil         -- the first of them

local function makeButton(k)
    local name = k == 1 and "OnwardItemButton" or ("OnwardItemButton" .. k)
    _G["BINDING_NAME_CLICK " .. name .. ":LeftButton"] = k == 1 and "Use quest item" or ("Use quest item " .. k)
    local b = CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate")
    b:SetSize(SIZE, SIZE)
    b:SetFrameStrata("HIGH")
    b:SetAttribute("type", "item")
    b:Hide()
    local tile = CreateFrame("Frame", nil, b)
    tile:SetAllPoints()
    tile:SetFrameLevel(math.max(0, b:GetFrameLevel() - 1))
    W.Skin.Glass(tile, { alpha = 0.85, corner = 8, shadow = true })
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetPoint("TOPLEFT", 2, -2)
    b.icon:SetPoint("BOTTOMRIGHT", -2, 2)
    b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    b.count = b:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    b.count:SetPoint("BOTTOMRIGHT", -1, 1)
    b.count:SetTextColor(1, 1, 1)
    b.cd = CreateFrame("Cooldown", nil, b, "CooldownFrameTemplate")
    b.cd:SetAllPoints(b.icon)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if self.itemId and GameTooltip.SetItemByID then GameTooltip:SetItemByID(self.itemId) else GameTooltip:AddLine("Use quest item") end
        GameTooltip:AddLine("Bind a key: Key Bindings > AddOns > Onward", 0.6, 0.6, 0.6)
        if pending then GameTooltip:AddLine("Updates when combat ends", 1, 0.6, 0.4) end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return b
end
for k = 1, MAX do buttons[k] = makeButton(k) end
IT.buttons = buttons
IT.button = buttons[1]

---------------------------------------------------------------------------
-- finding the item
---------------------------------------------------------------------------
local function itemCount(id)
    local n = (C_Item and C_Item.GetItemCount and C_Item.GetItemCount(id)) or (GetItemCount and GetItemCount(id)) or 0
    return W.Safe(n) or 0
end

local function usable(id)
    local spell = (C_Item and C_Item.GetItemSpell and C_Item.GetItemSpell(id)) or (GetItemSpell and GetItemSpell(id))
    return W.Safe(spell) ~= nil
end

local QUEST_CLASS = 12
local function itemClass(id)
    local f = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
    if not f then return end
    local _, _, _, _, _, class = f(id)
    return W.Safe(class)
end

local function itemName(id)
    local n = (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(id)) or (GetItemInfo and (GetItemInfo(id)))
    return W.Safe(n)
end

-- usable quest items in your bags: { id, ... }
function IT.BagQuestItems()
    local C = C_Container
    local slots = (C and C.GetContainerNumSlots) or GetContainerNumSlots
    local idAt = (C and C.GetContainerItemID) or GetContainerItemID
    local out, seen = {}, {}
    if not (slots and idAt) then return out end
    for bag = 0, 4 do
        for slot = 1, (W.Safe(slots(bag)) or 0) do
            local id = W.Safe(idAt(bag, slot))
            if id and not seen[id] then
                seen[id] = true
                if itemClass(id) == QUEST_CLASS and usable(id) then out[#out + 1] = id end
            end
        end
    end
    return out
end

-- "Wood Bundles" in the text names "Wood Bundle"; matched on whole words, case-insensitive
local function names(text, name)
    if not (text and name) or name == "" then return false end
    local n = name:lower():gsub("%p", "%%%0")
    local t = " " .. text:lower():gsub("[%c]", " ") .. " "
    return t:find("[^%w]" .. n .. "[^%w]") ~= nil or t:find("[^%w]" .. n .. "e?s[^%w]") ~= nil
end
IT.Names = names

-- the items for a step: the guide's, then the bag quest items the quest's text names
function IT.ItemsFor(step)
    local out = {}
    if not step or not step.quest then return out end
    if step.item and itemCount(step.item) > 0 and usable(step.item) then out[1] = step.item end
    if step.verb ~= "complete" then return out end
    local e = QS:Get(step.quest)
    if not e then return out end
    local text = { QS:ObjectiveText(step.quest) or "", QS:Description(step.quest) or "" }
    for _, o in ipairs(e.objectives or {}) do text[#text + 1] = o.text or "" end
    text = table.concat(text, " ")
    for _, id in ipairs(IT.BagQuestItems()) do
        if id ~= step.item and names(text, itemName(id)) then out[#out + 1] = id end
    end
    return out
end
function IT.For(step) return IT.ItemsFor(step)[1] end

-- items across the steps the card shows (the current step and those worked with it), no repeats
function IT.ForGroup()
    local out, seen = {}, {}
    local steps = G:Group()
    if #steps == 0 then steps = { G:Current() } end
    for _, s in ipairs(steps) do
        for _, id in ipairs(IT.ItemsFor(s)) do
            if not seen[id] and #out < MAX then seen[id] = true out[#out + 1] = id end
        end
    end
    return out
end

function IT.Has(id)
    for _, v in ipairs(IT.items) do if v == id then return true end end
    return false
end

---------------------------------------------------------------------------
-- placement: a row beside the target button (leftwards on the card, rightwards when detached)
---------------------------------------------------------------------------
local function place(b, k)
    local TG = W.Target
    local tb = TG and TG.button
    local slot = k - 1 + ((tb and tb:IsShown()) and 1 or 0)
    if TG and TG.Detached() then
        b:SetScale(1)
        b:SetSize(BIG, BIG)
        b:ClearAllPoints()
        local p = W.db.targetPoint
        local dx = slot * (BIG + 6)
        if p then b:SetPoint(p[1], UIParent, p[2], p[3] + dx, p[4]) else b:SetPoint("BOTTOM", UIParent, "BOTTOM", dx, 190) end
        return true
    end
    b:SetSize(SIZE, SIZE)
    local card = W.UI and W.UI.card
    local panel = W.UI and W.UI.panel
    if not (card and panel and panel:IsShown() and card:GetRight()) then return false end
    b:SetScale(panel:GetEffectiveScale() / UIParent:GetEffectiveScale())
    b:ClearAllPoints()
    b:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", card:GetRight() + 4 - slot * (SIZE + GAP), card:GetTop() + 3)
    return true
end

local function refreshLook()
    for _, b in ipairs(buttons) do
        local id = b.itemId
        if id and b:IsShown() then
            local tex = (C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(id)) or (GetItemIcon and GetItemIcon(id))
            b.icon:SetTexture(W.Safe(tex) or 134400)
            local n = itemCount(id)
            b.count:SetText(n > 1 and tostring(n) or "")
            local f = (C_Container and C_Container.GetItemCooldown) or GetItemCooldown
            if f then
                local start, dur = f(id)
                b.cd:SetCooldown(W.Safe(start) or 0, W.Safe(dur) or 0)
            end
        end
    end
end

function IT:Sync()
    if InCombatLockdown and InCombatLockdown() then pending = true return end
    pending = false
    local items = W.db.itemButton ~= false and IT.ForGroup() or {}
    IT.items, IT.item = items, items[1]
    local shown = 0
    for k, b in ipairs(buttons) do
        local id = items[k]
        b.itemId = id
        b:SetAttribute("item", id and ("item:" .. id) or nil)
        local show = id and place(b, k)
        b:SetShown(show and true or false)
        if show then shown = shown + 1 end
    end
    refreshLook()
    local detached = W.Target and W.Target.Detached()
    if W.UI and W.UI.SetCardInset then W.UI.SetCardInset(detached and 0 or shown * (SIZE + GAP), "item") end
end

local function registerClicks()
    local down = GetCVarBool and GetCVarBool("ActionButtonUseKeyDown")
    for _, b in ipairs(buttons) do b:RegisterForClicks(down and "LeftButtonDown" or "LeftButtonUp") end
end

local function sync() IT:Sync() end
W:On("WF_INIT", function() registerClicks() sync() end)
W:On("BAG_UPDATE_DELAYED", sync)
W:On("BAG_UPDATE_COOLDOWN", refreshLook)
W:On("PLAYER_REGEN_ENABLED", function() if pending then sync() end end)
W:On("CVAR_UPDATE", function() if not (InCombatLockdown and InCombatLockdown()) then registerClicks() end end)
