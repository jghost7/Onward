-- Voluntary cleanup for leftover quest items whose entire quest chain is completed.
--
-- Safety rules:
--   1. Never automatic: nothing is ever deleted on events or timers. Deletion runs ONLY when the
--      player explicitly clicks a Delete button (one item per hardware click).
--   2. Allowlist only: an item must exist in W.QuestItemQuests (built offline by
--      tools/make_quest_items.py from QuestieDB + Forever DB2, excluding quest rewards, repeatable
--      quest items, tradable/BoE/vendorable/equippable/openable/Rare+ items, and dungeon tools).
--   3. Every quest listed for the player's faction (plus any live Questie relatedQuests) must be
--      flagged completed and NOT in the quest log.
--   4. No quest currently in the player's quest log may mention the item's name in its title,
--      objectives, or description.
--   5. Re-verified live at click time (same itemID in bag/slot, unlocked, out of combat, empty
--      cursor) before calling PickupContainerItem + DeleteCursorItem.
local _, W = ...
local CL = {}
W.Cleanup = CL

local QS, QB, S = W.QuestState, W.QuestieBridge, W.Skin
local QUEST_CLASS = 12
local MAX_BAG = 4   -- backpack (0) + equipped bags (1..4); never touches bank

local dirty = true
local cached = {}

local function factionKey()
    local f = W.PlayerFaction and W.PlayerFaction() or (UnitFactionGroup and UnitFactionGroup("player"))
    return f and f:sub(1, 1):upper() or "A"
end

local function keptSet()
    if not W.cdb then return {} end
    W.cdb.keptItems = W.cdb.keptItems or {}
    return W.cdb.keptItems
end

local function numSlots(bag)
    local fn = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
    return fn and (W.Safe(fn(bag)) or 0) or 0
end

local function slotInfo(bag, slot)
    if C_Container and C_Container.GetContainerItemInfo then
        local info = C_Container.GetContainerItemInfo(bag, slot)
        if not info or not info.itemID then return nil end
        return {
            id = W.Safe(info.itemID),
            count = W.Safe(info.stackCount) or 1,
            icon = W.Safe(info.iconFileID),
            locked = W.Safe(info.isLocked) and true or false,
            link = W.Safe(info.hyperlink),
        }
    end
    if GetContainerItemInfo then
        local icon, count, locked, _, _, _, link, _, _, id = GetContainerItemInfo(bag, slot)
        if not id and link then id = tonumber(link:match("item:(%d+)")) end
        if not id then return nil end
        return { id = id, count = count or 1, icon = icon, locked = locked and true or false, link = link }
    end
end

local function itemName(id, link)
    local n = (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(id))
        or (GetItemInfo and (GetItemInfo(id)))
    n = W.Safe(n)
    if (not n or n == "") and link then n = link:match("%[(.-)%]") end
    return n
end

local function isQuestClass(id)
    local f = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
    if not f then return true end
    local _, _, _, _, _, classID = f(id)
    classID = W.Safe(classID)
    return classID == nil or classID == QUEST_CLASS
end

-- All quests for the player's faction that ever use this item (nil if not in the safe allowlist).
function CL:QuestsFor(id)
    local entry = W.QuestItemQuests and W.QuestItemQuests[id]
    if not entry then return nil end
    if entry[1] then return entry end
    return entry[factionKey()]
end

local function activeLogMentions(name)
    if not name or #name < 4 then return false end
    local needle = name:lower()
    for _, q in ipairs(QS:Order()) do
        local e = QS:Get(q)
        if e then
            if e.title and e.title:lower():find(needle, 1, true) then return true end
            for _, o in ipairs(e.objectives or {}) do
                if o.text and o.text:lower():find(needle, 1, true) then return true end
            end
        end
        local ot = QS:ObjectiveText(q)
        if ot and ot:lower():find(needle, 1, true) then return true end
        local desc = QS:Description(q)
        if desc and desc:lower():find(needle, 1, true) then return true end
    end
    return false
end

-- Returns true, questList when item `id` is verified obsolete with no further quest use.
function CL:IsSafeToDelete(id, name)
    if not id or keptSet()[id] then return false end
    local qs = CL:QuestsFor(id)
    if not qs or #qs == 0 then return false end
    if not isQuestClass(id) then return false end
    for _, q in ipairs(qs) do
        if QS:IsOnQuest(q) or not QS:IsDone(q) then return false end
    end
    -- Live Questie cross-check: if Questie knows any extra quest for this item that isn't done, refuse
    if QB and QB.ItemRelatedQuests and QB:IsReady() then
        local live = QB:ItemRelatedQuests(id)
        for _, q in ipairs(live or {}) do
            if QS:IsOnQuest(q) or not QS:IsDone(q) then return false end
        end
    end
    if activeLogMentions(name) then return false end
    return true, qs
end

function CL:Invalidate() dirty = true end

-- Scan bags 0..4 for verified obsolete quest items. Never modifies bags.
function CL:Scan(force)
    if not dirty and not force then return cached end
    wipe(cached)
    for bag = 0, MAX_BAG do
        for slot = 1, numSlots(bag) do
            local info = slotInfo(bag, slot)
            if info and info.id and not info.locked then
                local name = itemName(info.id, info.link)
                local safe, qs = CL:IsSafeToDelete(info.id, name)
                if safe then
                    cached[#cached + 1] = {
                        bag = bag, slot = slot, id = info.id,
                        name = name or ("Item " .. info.id),
                        icon = info.icon or 134400,
                        count = info.count or 1,
                        quests = qs,
                    }
                end
            end
        end
    end
    table.sort(cached, function(a, b)
        if a.name ~= b.name then return a.name < b.name end
        if a.bag ~= b.bag then return a.bag < b.bag end
        return a.slot < b.slot
    end)
    dirty = false
    return cached
end

function CL:Count()
    return #CL:Scan()
end

function CL:QuestNames(quests)
    local out = {}
    for _, q in ipairs(quests or {}) do
        out[#out + 1] = QS:Title(q) or ("quest " .. q)
    end
    return table.concat(out, ", ")
end

-- Mark an item as kept so Onward stops offering it for cleanup on this character.
function CL:Keep(id)
    if not id then return end
    keptSet()[id] = true
    dirty = true
    CL:Render()
    W:Fire("WF_UPDATED")
end

function CL:ResetKept()
    if W.cdb then W.cdb.keptItems = {} end
    dirty = true
    CL:Render()
    W:Fire("WF_UPDATED")
end

-- Voluntary deletion of ONE verified bag slot. Must be called from a user click handler.
function CL:DeleteEntry(entry)
    if not entry then return false, "no item" end
    if InCombatLockdown and InCombatLockdown() then
        W.Print("Can't delete quest items while in combat.")
        return false, "combat"
    end
    if GetCursorInfo and GetCursorInfo() then
        W.Print("Your cursor is holding something; clear it before deleting an item.")
        return false, "cursor"
    end
    local info = slotInfo(entry.bag, entry.slot)
    if not info or info.id ~= entry.id or info.locked then
        dirty = true
        CL:Render()
        W.Print("That item moved or is locked; list refreshed.")
        return false, "moved"
    end
    local name = itemName(info.id, info.link) or entry.name
    local safe, qs = CL:IsSafeToDelete(info.id, name)
    if not safe then
        dirty = true
        CL:Render()
        W.Print(name .. " is no longer eligible for cleanup.")
        return false, "unsafe"
    end
    local pickup = (C_Container and C_Container.PickupContainerItem) or PickupContainerItem
    if not (pickup and DeleteCursorItem) then return false, "api" end
    pickup(entry.bag, entry.slot)
    if GetCursorInfo then
        local kind, cid = GetCursorInfo()
        if kind ~= "item" or cid ~= entry.id then
            if ClearCursor then ClearCursor() end
            return false, "mismatch"
        end
    end
    DeleteCursorItem()
    W.Print(("Deleted %s (completed: %s)."):format(name, CL:QuestNames(qs)))
    dirty = true
    CL:Render()
    W:Fire("WF_UPDATED")
    return true
end

---------------------------------------------------------------------------
-- Voluntary cleanup window (OnwardCleanup)
---------------------------------------------------------------------------
local WIN_W, ROW_H, MAX_ROWS = 430, 38, 9
local win, rows, emptyText, countText, delNextBtn
local offset = 0

local function makeFS(parent, size, r, g, b)
    local t = parent:CreateFontString(nil, "OVERLAY")
    S.Font(t, size, "body")
    if r == S.ACCENT then S.Accent(t, "text") else t:SetTextColor(r or 0.93, g or 0.94, b or 0.96) end
    t:SetShadowColor(0, 0, 0, 0.6)
    t:SetShadowOffset(1, -1)
    t:SetJustifyH("LEFT")
    return t
end

local function smallBtn(parent, w, h, label, accent)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(w, h)
    local bg = S.Nine(b, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 6, 0)
    bg:SetColor(1, 1, 1, accent and 0.14 or 0.08)
    b.bg = bg
    local t = makeFS(b, 11, accent and S.ACCENT or 0.85, 0.87, 0.90)
    t:SetPoint("CENTER")
    t:SetJustifyH("CENTER")
    t:SetText(label)
    b.label = t
    b:SetScript("OnEnter", function()
        bg:SetColor(S.ACCENT[1], S.ACCENT[2], S.ACCENT[3], 0.30)
        t:SetTextColor(1, 1, 1)
    end)
    b:SetScript("OnLeave", function()
        bg:SetColor(1, 1, 1, accent and 0.14 or 0.08)
        if accent then t:SetTextColor(S.ACCENT[1], S.ACCENT[2], S.ACCENT[3])
        else t:SetTextColor(0.85, 0.87, 0.90) end
    end)
    return b
end

local function buildWindow()
    if win then return win end
    win = CreateFrame("Frame", "OnwardCleanup", UIParent)
    win:SetSize(WIN_W, 430)
    win:SetPoint("CENTER")
    win:SetFrameStrata("DIALOG")
    win:SetClampedToScreen(true)
    win:SetMovable(true)
    win:EnableMouse(true)
    win:EnableMouseWheel(true)
    win:RegisterForDrag("LeftButton")
    win:SetScript("OnDragStart", win.StartMoving)
    win:SetScript("OnDragStop", win.StopMovingOrSizing)
    win:Hide()
    if UISpecialFrames then table.insert(UISpecialFrames, "OnwardCleanup") end
    S.Glass(win, { alpha = 0.90, corner = 12, titleBar = 38 })

    local title = makeFS(win, 15, S.ACCENT)
    title:SetPoint("TOPLEFT", 16, -12)
    title:SetText("Completed quest items")

    local close = CreateFrame("Button", nil, win)
    close:SetSize(24, 24)
    close:SetPoint("TOPRIGHT", -8, -7)
    local x = makeFS(close, 15, 0.62, 0.65, 0.70)
    x:SetPoint("CENTER")
    x:SetText("x")
    close:SetScript("OnClick", function() win:Hide() end)
    close:SetScript("OnEnter", function() x:SetTextColor(1, 1, 1) end)
    close:SetScript("OnLeave", function() x:SetTextColor(0.62, 0.65, 0.70) end)

    local sub = makeFS(win, 11, 0.66, 0.70, 0.75)
    sub:SetPoint("TOPLEFT", 16, -44)
    sub:SetPoint("RIGHT", -16, 0)
    sub:SetWordWrap(true)
    sub:SetText("Only soulbound quest items whose entire quest chain is finished. Nothing is deleted automatically — click Delete for each item you want to remove.")

    rows = {}
    for i = 1, MAX_ROWS do
        local r = CreateFrame("Frame", nil, win)
        r:SetSize(WIN_W - 28, ROW_H)
        r:SetPoint("TOPLEFT", 14, -76 - (i - 1) * (ROW_H + 2))
        r:EnableMouse(true)
        local hl = r:CreateTexture(nil, "BACKGROUND")
        hl:SetAllPoints()
        hl:SetColorTexture(1, 1, 1, 0.05)
        hl:Hide()
        r.icon = r:CreateTexture(nil, "ARTWORK")
        r.icon:SetSize(26, 26)
        r.icon:SetPoint("LEFT", 4, 0)
        r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        r.name = makeFS(r, 12, 0.95, 0.96, 0.98)
        r.name:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 8, -1)
        r.name:SetPoint("RIGHT", -122, 0)
        r.name:SetWordWrap(false)
        r.quest = makeFS(r, 10, 0.58, 0.62, 0.68)
        r.quest:SetPoint("BOTTOMLEFT", r.icon, "BOTTOMRIGHT", 8, 1)
        r.quest:SetPoint("RIGHT", -122, 0)
        r.quest:SetWordWrap(false)

        r.keep = smallBtn(r, 48, 22, "Keep", false)
        r.keep:SetPoint("RIGHT", -64, 0)
        r.keep:SetScript("OnClick", function()
            if r.entry then CL:Keep(r.entry.id) end
        end)

        r.del = smallBtn(r, 56, 22, "Delete", true)
        r.del:SetPoint("RIGHT", -4, 0)
        r.del:SetScript("OnClick", function()
            if r.entry then CL:DeleteEntry(r.entry) end
        end)

        r:SetScript("OnEnter", function(self)
            hl:Show()
            if not self.entry then return end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if GameTooltip.SetBagItem then
                GameTooltip:SetBagItem(self.entry.bag, self.entry.slot)
            else
                GameTooltip:AddLine(self.entry.name, 1, 1, 1)
            end
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Completed quest(s): " .. CL:QuestNames(self.entry.quests), 0.4, 0.85, 0.45, true)
            GameTooltip:AddLine("No further quests in Onward's database use this item.", 0.7, 0.7, 0.7, true)
            GameTooltip:Show()
        end)
        r:SetScript("OnLeave", function() hl:Hide() GameTooltip:Hide() end)
        r:Hide()
        rows[i] = r
    end

    emptyText = makeFS(win, 12, 0.62, 0.66, 0.72)
    emptyText:SetPoint("CENTER", 0, 10)
    emptyText:SetJustifyH("CENTER")
    emptyText:SetText("No leftover quest items in your bags.")
    emptyText:Hide()

    countText = makeFS(win, 11, 0.62, 0.66, 0.72)
    countText:SetPoint("BOTTOMLEFT", 16, 16)

    delNextBtn = smallBtn(win, 96, 24, "Delete next", true)
    delNextBtn:SetPoint("BOTTOMRIGHT", -84, 11)
    delNextBtn:SetScript("OnClick", function()
        local list = CL:Scan(true)
        if list[1] then CL:DeleteEntry(list[1]) end
    end)

    local closeBtn = smallBtn(win, 64, 24, "Close", false)
    closeBtn:SetPoint("BOTTOMRIGHT", -14, 11)
    closeBtn:SetScript("OnClick", function() win:Hide() end)

    win:SetScript("OnMouseWheel", function(_, delta)
        local list = CL:Scan()
        local maxOff = math.max(0, #list - MAX_ROWS)
        offset = math.max(0, math.min(maxOff, offset - delta))
        CL:Render()
    end)

    CL.win = win
    return win
end

function CL:Render()
    if not win or not win:IsShown() then return end
    local list = CL:Scan()
    local maxOff = math.max(0, #list - MAX_ROWS)
    if offset > maxOff then offset = maxOff end
    for i, r in ipairs(rows) do
        local e = list[i + offset]
        r.entry = e
        if e then
            r.icon:SetTexture(e.icon or 134400)
            r.name:SetText(e.count > 1 and ("%s x%d"):format(e.name, e.count) or e.name)
            r.quest:SetText("Done: " .. CL:QuestNames(e.quests))
            r:Show()
        else
            r:Hide()
        end
    end
    emptyText:SetShown(#list == 0)
    delNextBtn:SetShown(#list > 0)
    countText:SetText(#list > 0 and ("%d item%s (1 click = 1 delete)"):format(#list, #list == 1 and "" or "s") or "All clear")
end

function CL:Show()
    buildWindow()
    dirty = true
    win:Show()
    CL:Render()
end

function CL:Hide()
    if win then win:Hide() end
end

function CL:Toggle()
    if win and win:IsShown() then win:Hide() else CL:Show() end
end

---------------------------------------------------------------------------
-- Events (read-only cache invalidation; NEVER deletes anything)
---------------------------------------------------------------------------
local lastCount = 0
local function onChange()
    dirty = true
    if win and win:IsShown() then CL:Render() end
    local n = (W.db and W.db.bagCleanup ~= false) and CL:Count() or 0
    if n ~= lastCount then
        lastCount = n
        W:Fire("WF_UPDATED")
    end
end

W:On("BAG_UPDATE_DELAYED", onChange)
W:On("QUEST_TURNED_IN", function() C_Timer.After(0.4, onChange) end)
W:On("QUEST_ACCEPTED", onChange)
W:On("QUEST_REMOVED", onChange)
W:On("PLAYER_ENTERING_WORLD", function() C_Timer.After(2, onChange) end)
W:On("WF_SHOW_CLEANUP", function() CL:Show() end)
