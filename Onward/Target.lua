-- Quest-mob targeting: a crosshair button on the current step card, plus a key binding
-- (Key Bindings > AddOns > Onward). Each press targets the nearest living quest mob for the
-- current step and, if set, marks it with a skull.
-- On a step where you talk to someone (accept, turn in, set your hearthstone, train) the same
-- button targets that NPC instead and marks them with a star, so you can pick them out of a
-- crowded town. It doesn't talk for you: right-click them, or use the game's interact key.
--
-- Targeting by name is protected, so this is a SecureActionButton running a /targetexact macro.
-- Blizzard only lets a secure button change its macro or move out of combat: the macro is rebuilt
-- whenever the step or its objectives change, and a change made in combat waits for combat to end.
-- The button is parented to UIParent and placed by screen position, never anchored to the panel,
-- so the panel stays free to resize and redraw during combat.
--
-- Detached (Options > Navigation): an action-button-sized version that lives wherever you drag
-- it (right-drag), e.g. beside your action bars, instead of on the step card.
local _, W = ...
local TG = {}
W.Target = TG

local G, QS = W.Guide, W.QuestState
local MEDIA = "Interface\\AddOns\\Onward\\media\\"
local SIZE = 26           -- in the card's action strip
local BIG = 40           -- detached: about an action button
local MACRO_MAX = 255

BINDING_HEADER_ONWARD = "Onward"
_G["BINDING_NAME_CLICK OnwardTargetButton:LeftButton"] = "Target quest mob or NPC"

local b = CreateFrame("Button", "OnwardTargetButton", UIParent, "SecureActionButtonTemplate")
b:SetSize(SIZE, SIZE)
b:SetFrameStrata("HIGH")
b:SetAttribute("type", "macro")
b:SetAttribute("macrotext", "")
b:Hide()

local hover = b:CreateTexture(nil, "BACKGROUND")
hover:SetAllPoints()
hover:SetTexture(MEDIA .. "circle")
hover:SetVertexColor(1, 1, 1, 0.10)
-- detached look: a glass tile behind the button (a plain child frame; the secure button itself
-- is never reparented or resized in combat)
local tile = CreateFrame("Frame", nil, b)
tile:SetAllPoints()
tile:SetFrameLevel(math.max(0, b:GetFrameLevel() - 1))
W.Skin.Glass(tile, { alpha = 0.85, corner = 8, shadow = true })
tile:Hide()
local icon = b:CreateTexture(nil, "ARTWORK")
icon:SetSize(14, 14)
icon:SetPoint("CENTER")
icon:SetTexture(MEDIA .. "complete")
TG.button, TG.icon = b, icon

TG.mobs = {}          -- names in the live macro
local pending = false -- a rebuild is waiting for combat to end

---------------------------------------------------------------------------
-- which mobs: the guide's list, plus "<Name> slain" objectives. A mob drops out once what it's
-- there for is done: its kill objective, or the item it drops ("Mob@Item" in the guide). A mob
-- the guide doesn't tie to an item drops out when a finished objective is named after it
-- ("Sand Crawler" for "Sand Crawler Meat") and no unfinished one is.
---------------------------------------------------------------------------
-- an objective's name without its count: "Sand Crawler Meat: 3/6" / "3/6 Sand Crawler Meat"
local function objName(text)
    if not text then return nil end
    return text:match("^(.-):%s*%d+%s*/%s*%d+") or text:match("^%d+%s*/%s*%d+%s+(.+)$") or text
end
local function plain(s) return (s:gsub("%p", "%%%0")) end
function TG.MobsFor(step)
    if not step or step.verb ~= "complete" or not step.quest then return {} end
    local out, seen, done = {}, {}, {}
    local e = QS:Get(step.quest)
    local finished, open = {}, {}
    for _, o in ipairs(e and e.objectives or {}) do
        local n = objName(o.text)
        if n then if o.finished then finished[n] = true else open[#open + 1] = n end end
    end
    local function stillNeeded(name)
        local item = step.mobItem and step.mobItem[name]
        if item then return not finished[item] end
        local named = false
        for n in pairs(finished) do if n:find("^" .. plain(name)) then named = true end end
        if not named then return true end
        for _, n in ipairs(open) do if n:find(plain(name)) then return true end end
        return false
    end
    local function add(name)
        if name and name ~= "" and not seen[name] and not done[name] then
            seen[name] = true
            out[#out + 1] = name
        end
    end
    if e then
        for _, o in ipairs(e.objectives or {}) do
            local name = o.text and (o.text:match("^(.-) slain:") or o.text:match("^(.-) killed:"))
            if name and o.finished then done[name] = true end
        end
        for _, o in ipairs(e.objectives or {}) do
            if not o.finished then
                add(o.text and (o.text:match("^(.-) slain:") or o.text:match("^(.-) killed:")))
            end
        end
    end
    for _, name in ipairs(step.mobs or {}) do
        if stillNeeded(name) then add(name) end
    end
    return out
end

-- Mobs for a group of steps worked together (G:Group), taken in turn from each quest so every
-- quest gets its first-choice mob into the macro before any quest gets a second.
function TG.MobsForGroup(steps)
    local lists, out, seen = {}, {}, {}
    for i, s in ipairs(steps or {}) do lists[i] = TG.MobsFor(s) end
    for round = 1, 8 do
        for _, l in ipairs(lists) do
            local name = l[round]
            if name and not seen[name] then seen[name] = true out[#out + 1] = name end
        end
    end
    return out
end

-- /cleartarget, then /targetexact each name while there is no living target; names past the
-- 255-character macro limit are left out (the first ones are the ones that matter)
-- plate: a nameplate token ("nameplate7") holding an untagged quest mob, tried first; the names
-- follow as the fallback, so the button works the same without nameplates
function TG.BuildMacro(names, mark, plate)
    local lines = { "/cleartarget" }
    if plate and #names > 0 then lines[2] = ("/target [@%s,exists,nodead,harm] %s"):format(plate, plate) end
    -- skull via the secure /tm command: Lua from a macro (/run) is force-tainted on this client and
    -- SetRaidTarget is blocked ("ForceTaint_Strong has been blocked"). /tm 8 toggles, so clear first.
    local tail = "/cleartarget [dead]" .. (mark and "\n/tm [exists,nodead] 0\n/tm [exists,nodead] 8" or "")
    local budget = MACRO_MAX - #tail - 1
    local used = #table.concat(lines, "\n")
    for i, name in ipairs(names) do
        local add = ((i == 1 and not plate) and "/targetexact " or "/targetexact [noexists][dead] ") .. name
        if used + 1 + #add > budget then break end
        lines[#lines + 1] = add
        used = used + 1 + #add
    end
    if #lines == 1 then return "" end
    lines[#lines + 1] = tail
    return table.concat(lines, "\n")
end

-- Who a step has you talk to, by name: the NPC the guide names, else the one the arrow found.
-- Fly steps name the far end's flight master, not the one in front of you, so they have none.
local TALK = { accept = true, turnin = true, home = true, train = true }
function TG.TalkName(step)
    if not step or not TALK[step.verb] then return nil end
    local name = step.npc
    if not name then
        local cur = W.Waypoint and W.Waypoint:Current()
        name = cur and cur.step == step and cur.name or nil
    end
    if type(name) ~= "string" or name == "" or #name > 60 then return nil end
    return name
end

-- target them by exact name; star via /tm (cleared first, since /tm toggles)
function TG.BuildTalkMacro(name, mark)
    return "/cleartarget\n/targetexact " .. name .. (mark and "\n/tm [exists,nodead] 0\n/tm [exists,nodead] 1" or "")
end

---------------------------------------------------------------------------
-- placement: top-right corner of the step card, by screen position
---------------------------------------------------------------------------
local function detached() return W.db.targetDetached and true or false end
TG.Detached = detached

local function placeDetached()
    b:SetScale(1)
    b:SetSize(BIG, BIG)
    icon:SetSize(26, 26)
    tile:Show()
    b:ClearAllPoints()
    local p = W.db.targetPoint
    if p then b:SetPoint(p[1], UIParent, p[2], p[3], p[4]) else b:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 190) end
    return true
end

local function place()
    if detached() then return placeDetached() end
    b:SetSize(SIZE, SIZE)
    icon:SetSize(16, 16)
    tile:Show()
    local strip = W.UI and W.UI.strip
    local panel = W.UI and W.UI.panel
    if not (strip and panel and panel:IsShown() and strip:IsVisible() and strip:GetLeft()) then return false end
    b:SetScale(panel:GetEffectiveScale() / UIParent:GetEffectiveScale())
    b:ClearAllPoints()
    -- strip and button share a coordinate scale, so the strip's edges can be used directly:
    -- the first slot of the action strip under the step title
    b:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", strip:GetLeft(), strip:GetTop() - 1)
    return true
end

-- Untagged first (needs enemy nameplates; out of combat only): the nameplate of a living quest
-- mob nobody else has tagged, the one nearest the middle of the screen (nameplates carry no
-- distance; the middle is what you're facing). A macro can't test "tagged", so Sync writes this
-- one mob's token into it, and refreshes it as plates come and go and tags change.
function TG.UntaggedPlate(names)
    local want = {}
    for _, n in ipairs(names or {}) do want[n] = true end
    if not next(want) then return nil end
    local cx, cy = UIParent:GetCenter()
    local best, bestD
    for i = 1, 40 do
        local u = "nameplate" .. i
        local name = W.Safe(UnitName(u))
        if name and want[name] and not W.Safe(UnitIsDead(u)) and not W.Safe(UnitIsTapDenied(u))
           and W.Safe(UnitCanAttack("player", u)) then
            local d = i * 1e-6                                   -- no position: token order
            local plate = C_NamePlate and C_NamePlate.GetNamePlateForUnit and C_NamePlate.GetNamePlateForUnit(u)
            local x, y
            if plate and plate.GetCenter then x, y = plate:GetCenter() end
            if x and cx then d = (x - cx) ^ 2 + (y - cy) ^ 2 end
            if not bestD or d < bestD then best, bestD = u, d end
        end
    end
    return best
end

local namesOnly = false   -- entering combat: drop the plate line (tokens shift while it's locked)
function TG:Sync()
    if InCombatLockdown and InCombatLockdown() then pending = true return end
    pending = false
    local group = W.db.targetButton and G:Group() or {}   -- the steps the card shows
    local names = TG.MobsForGroup(group)
    TG.plate = (not namesOnly) and TG.UntaggedPlate(names) or nil
    local macro = TG.BuildMacro(names, W.db.targetMark, TG.plate)
    TG.mobs = {}
    for _, name in ipairs(names) do   -- only what made it into the macro (tooltip honesty)
        if macro:find("/targetexact[^\n]* " .. name:gsub("%p", "%%%0") .. "\n") then TG.mobs[#TG.mobs + 1] = name end
    end
    TG.talk = nil
    if #names == 0 and W.db.targetButton then
        TG.talk = TG.TalkName(G:Current())
        if TG.talk then macro = TG.BuildTalkMacro(TG.talk, W.db.targetMark) end
    end
    icon:SetTexture(MEDIA .. (TG.talk and "who" or "complete"))
    b:SetAttribute("macrotext", macro)
    local show = (#names > 0 or TG.talk) and place()
    b:SetShown(show and true or false)
    if W.Item then W.Item:Sync() end   -- it sits beside this button
    if W.UI and W.UI.SetCardInset then W.UI.SetCardInset((show and not detached()) and (SIZE + 2) or 0, "target") end
end

---------------------------------------------------------------------------
-- busy area: how many of the step's quest mobs on nameplates around you are tagged by others
---------------------------------------------------------------------------
-- returns tagged, total over living mobs named in the step group's macro (needs enemy nameplates)
function TG:Crowd()
    local want = {}
    for _, name in ipairs(TG.MobsForGroup(G:Group())) do want[name] = true end
    if not next(want) then return 0, 0 end
    local tagged, total = 0, 0
    for i = 1, 40 do
        local u = "nameplate" .. i
        local name = W.Safe(UnitName(u))
        if name and want[name] and not W.Safe(UnitIsDead(u)) then
            total = total + 1
            if W.Safe(UnitIsTapDenied(u)) then tagged = tagged + 1 end
        end
    end
    return tagged, total
end

-- busy = at least 3 quest mobs in sight and most of them (60%) tagged by someone else
function TG:Busy()
    local tagged, total = TG:Crowd()
    return total >= 3 and tagged >= 0.6 * total, tagged, total
end

---------------------------------------------------------------------------
-- look and tooltip
---------------------------------------------------------------------------
local ACC = W.Skin.ACCENT       -- shared with the theme; read live on hover
W.Skin.Accent(icon, "vertex")
local function themeHover()   -- the button's backdrop follows the theme: circle or square
    if W.Skin.Square() then hover:SetTexture("Interface\\Buttons\\WHITE8x8") else hover:SetTexture(MEDIA .. "circle") end
end
themeHover()
W:On("WF_THEME_CHANGED", themeHover)
b:SetScript("OnEnter", function(self)
    hover:SetVertexColor(ACC[1], ACC[2], ACC[3], 0.28)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine(TG.talk and "Target who you talk to" or "Target quest mob")
    if TG.talk then GameTooltip:AddLine(TG.talk, 0.93, 0.94, 0.96) end
    for _, name in ipairs(TG.mobs) do GameTooltip:AddLine(name, 0.93, 0.94, 0.96) end
    GameTooltip:AddLine("Bind a key: Key Bindings > AddOns > Onward", 0.6, 0.6, 0.6)
    if detached() then GameTooltip:AddLine("Right-drag to move", 0.6, 0.6, 0.6) end
    if pending then GameTooltip:AddLine("Updates when combat ends", 1, 0.6, 0.4) end
    GameTooltip:Show()
end)
b:SetScript("OnLeave", function()
    hover:SetVertexColor(1, 1, 1, 0.10)
    GameTooltip:Hide()
end)

-- key bindings fire on key-down or key-up depending on the client setting; register for exactly
-- one so the macro doesn't run twice per press
local function registerClicks()
    local down = GetCVarBool and GetCVarBool("ActionButtonUseKeyDown")
    -- left button only: right is for dragging the detached button
    b:RegisterForClicks(down and "LeftButtonDown" or "LeftButtonUp")
end

-- moving the detached button: right-drag, out of combat (a secure button can't move in combat)
b:SetMovable(true)
b:RegisterForDrag("RightButton")
b:SetScript("OnDragStart", function(self)
    if detached() and not (InCombatLockdown and InCombatLockdown()) then self:StartMoving() end
end)
b:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    if not detached() then return end
    local p, _, rp, x, y = self:GetPoint()
    W.db.targetPoint = { p, rp, x, y }
end)

local function sync() TG:Sync() end
W:On("WF_INIT", function() registerClicks() sync() end)
W:On("WF_UPDATED", sync)
W:On("WF_QUEST_STATE", sync)
W:On("WF_SETTINGS_CHANGED", sync)
W:On("WF_RESET_POSITION", function() W.db.targetPoint = nil sync() end)
W:On("WF_PANEL_MOVED", sync)
W:On("WF_TOGGLE_PANEL", sync)
W:On("PLAYER_REGEN_ENABLED", function() namesOnly = false sync() end)
-- PLAYER_REGEN_DISABLED comes just before the lockdown: the last chance to take the plate line
-- out, since in combat a token can move on to another mob and nothing could correct it
W:On("PLAYER_REGEN_DISABLED", function()
    if TG.plate then namesOnly = true sync() end
end)
-- out of combat, keep the picked plate current (coalesced: plates come in bursts)
local queued = false
local function soon()
    if queued or (InCombatLockdown and InCombatLockdown()) or not b:IsShown() then return end
    queued = true
    C_Timer.After(0.2, function() queued = false sync() end)
end
W:On("NAME_PLATE_UNIT_ADDED", soon)
W:On("NAME_PLATE_UNIT_REMOVED", soon)
W:On("UNIT_FLAGS", function(_, u) if type(u) == "string" and u:find("^nameplate") then soon() end end)
W:On("CVAR_UPDATE", function() if not (InCombatLockdown and InCombatLockdown()) then registerClicks() end end)
