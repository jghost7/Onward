-- Quest item button: on a step whose quest has you use an item (fletch the Wood Bundles, throw
-- the spear at a crocolisk, read the satchel), a button that uses it, next to the target button.
-- Bind a key under Key Bindings > AddOns > Onward.
--
-- Which item: the one the guide names (|item <id>, the item the quest gives you), else a usable
-- quest item in your bags that the quest's own text names ("Collect Wood Bundles ..."). Only items
-- you have and that have a Use: effect count.
--
-- Like the target button it is a SecureActionButton: its item and position change only out of
-- combat, and a change in combat waits for combat to end.
local _, W = ...
local IT = {}
W.Item = IT

local G, QS = W.Guide, W.QuestState
local SIZE, BIG, GAP = 22, 40, 2

_G["BINDING_NAME_CLICK OnwardItemButton:LeftButton"] = "Use quest item"

local b = CreateFrame("Button", "OnwardItemButton", UIParent, "SecureActionButtonTemplate")
b:SetSize(SIZE, SIZE)
b:SetFrameStrata("HIGH")
b:SetAttribute("type", "item")
b:Hide()
local tile = CreateFrame("Frame", nil, b)
tile:SetAllPoints()
tile:SetFrameLevel(math.max(0, b:GetFrameLevel() - 1))
W.Skin.Glass(tile, { alpha = 0.85, corner = 8, shadow = true })
local icon = b:CreateTexture(nil, "ARTWORK")
icon:SetPoint("TOPLEFT", 2, -2)
icon:SetPoint("BOTTOMRIGHT", -2, 2)
icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
local count = b:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
count:SetPoint("BOTTOMRIGHT", -1, 1)
count:SetTextColor(1, 1, 1)
local cd = CreateFrame("Cooldown", nil, b, "CooldownFrameTemplate")
cd:SetAllPoints(icon)
IT.button, IT.icon = b, icon

IT.item = nil         -- item id on the button
local pending = false

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

-- the item for a step: the guide's, then a bag quest item the quest's text names
function IT.For(step)
    if not step or not step.quest then return nil end
    if step.item and itemCount(step.item) > 0 and usable(step.item) then return step.item end
    if step.verb ~= "complete" then return nil end
    local e = QS:Get(step.quest)
    if not e then return nil end
    local text = { QS:ObjectiveText(step.quest) or "", QS:Description(step.quest) or "" }
    for _, o in ipairs(e.objectives or {}) do text[#text + 1] = o.text or "" end
    text = table.concat(text, " ")
    for _, id in ipairs(IT.BagQuestItems()) do
        if names(text, itemName(id)) then return id end
    end
end

-- first item across the steps the card shows (the current step and those worked with it)
function IT.ForGroup()
    local group = G:Group()
    for _, s in ipairs(group) do
        local id = IT.For(s)
        if id then return id end
    end
    local cur = G:Current()
    return cur and IT.For(cur)
end

---------------------------------------------------------------------------
-- placement: beside the target button (left of it on the card, right of it when detached)
---------------------------------------------------------------------------
local function place()
    local TG = W.Target
    local tb = TG and TG.button
    local targetShown = tb and tb:IsShown()
    if TG and TG.Detached() then
        b:SetScale(1)
        b:SetSize(BIG, BIG)
        b:ClearAllPoints()
        local p = W.db.targetPoint
        local dx = targetShown and (BIG + 6) or 0
        if p then b:SetPoint(p[1], UIParent, p[2], p[3] + dx, p[4]) else b:SetPoint("BOTTOM", UIParent, "BOTTOM", dx, 190) end
        return true
    end
    b:SetSize(SIZE, SIZE)
    local card = W.UI and W.UI.card
    local panel = W.UI and W.UI.panel
    if not (card and panel and panel:IsShown() and card:GetRight()) then return false end
    b:SetScale(panel:GetEffectiveScale() / UIParent:GetEffectiveScale())
    b:ClearAllPoints()
    local dx = targetShown and (SIZE + GAP) or 0
    b:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", card:GetRight() + 4 - dx, card:GetTop() + 3)
    return true
end

local function refreshLook()
    local id = IT.item
    if not id then return end
    local tex = (C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(id)) or (GetItemIcon and GetItemIcon(id))
    icon:SetTexture(W.Safe(tex) or 134400)
    local n = itemCount(id)
    count:SetText(n > 1 and tostring(n) or "")
    local f = (C_Container and C_Container.GetItemCooldown) or GetItemCooldown
    if f then
        local start, dur = f(id)
        cd:SetCooldown(W.Safe(start) or 0, W.Safe(dur) or 0)
    end
end

function IT:Sync()
    if InCombatLockdown and InCombatLockdown() then pending = true return end
    pending = false
    local id = W.db.itemButton ~= false and IT.ForGroup() or nil
    IT.item = id
    b:SetAttribute("item", id and ("item:" .. id) or nil)
    local show = id and place()
    b:SetShown(show and true or false)
    if show then refreshLook() end
    local detached = W.Target and W.Target.Detached()
    if W.UI and W.UI.SetCardInset then W.UI.SetCardInset((show and not detached) and (SIZE + GAP) or 0, "item") end
end

b:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    if IT.item and GameTooltip.SetItemByID then GameTooltip:SetItemByID(IT.item) else GameTooltip:AddLine("Use quest item") end
    GameTooltip:AddLine("Bind a key: Key Bindings > AddOns > Onward", 0.6, 0.6, 0.6)
    if pending then GameTooltip:AddLine("Updates when combat ends", 1, 0.6, 0.4) end
    GameTooltip:Show()
end)
b:SetScript("OnLeave", function() GameTooltip:Hide() end)

local function registerClicks()
    local down = GetCVarBool and GetCVarBool("ActionButtonUseKeyDown")
    b:RegisterForClicks(down and "LeftButtonDown" or "LeftButtonUp")
end

local function sync() IT:Sync() end
W:On("WF_INIT", function() registerClicks() sync() end)
W:On("BAG_UPDATE_DELAYED", sync)
W:On("BAG_UPDATE_COOLDOWN", refreshLook)
W:On("PLAYER_REGEN_ENABLED", function() if pending then sync() end end)
W:On("CVAR_UPDATE", function() if not (InCombatLockdown and InCombatLockdown()) then registerClicks() end end)
