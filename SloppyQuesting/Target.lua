-- Quest-mob targeting: a crosshair button on the current step card, plus a key binding
-- (Key Bindings > AddOns > Sloppy Questing). Each press targets the nearest living quest mob for the
-- current step and, if set, marks it with a skull.
--
-- Targeting by name is protected, so this is a SecureActionButton running a /targetexact macro.
-- Blizzard only lets a secure button change its macro or move out of combat: the macro is rebuilt
-- whenever the step or its objectives change, and a change made in combat waits for combat to end.
-- The button is parented to UIParent and placed by screen position, never anchored to the panel,
-- so the panel stays free to resize and redraw during combat.
local _, W = ...
local TG = {}
W.Target = TG

local G, QS = W.Guide, W.QuestState
local MEDIA = "Interface\\AddOns\\SloppyQuesting\\media\\"
local SIZE = 22
local MACRO_MAX = 255

BINDING_HEADER_SLOPPYQUESTING = "Sloppy Questing"
_G["BINDING_NAME_CLICK SloppyQuestingTargetButton:LeftButton"] = "Target quest mob"

local b = CreateFrame("Button", "SloppyQuestingTargetButton", UIParent, "SecureActionButtonTemplate")
b:SetSize(SIZE, SIZE)
b:SetFrameStrata("HIGH")
b:SetAttribute("type", "macro")
b:SetAttribute("macrotext", "")
b:Hide()

local hover = b:CreateTexture(nil, "BACKGROUND")
hover:SetAllPoints()
hover:SetTexture(MEDIA .. "circle")
hover:SetVertexColor(1, 1, 1, 0.10)
local icon = b:CreateTexture(nil, "ARTWORK")
icon:SetSize(14, 14)
icon:SetPoint("CENTER")
icon:SetTexture(MEDIA .. "complete")
TG.button, TG.icon = b, icon

TG.mobs = {}          -- names in the live macro
local pending = false -- a rebuild is waiting for combat to end

---------------------------------------------------------------------------
-- which mobs: the guide's list, plus "<Name> slain" objectives; finished kills drop out
---------------------------------------------------------------------------
function TG.MobsFor(step)
    if not step or step.verb ~= "complete" or not step.quest then return {} end
    local out, seen, done = {}, {}, {}
    local e = QS:Get(step.quest)
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
    for _, name in ipairs(step.mobs or {}) do add(name) end
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
function TG.BuildMacro(names, mark)
    local lines = { "/cleartarget" }
    -- skull via the secure /tm command: Lua from a macro (/run) is force-tainted on this client and
    -- SetRaidTarget is blocked ("ForceTaint_Strong has been blocked"). /tm 8 toggles, so clear first.
    local tail = "/cleartarget [dead]" .. (mark and "\n/tm [exists,nodead] 0\n/tm [exists,nodead] 8" or "")
    local budget = MACRO_MAX - #tail - 1
    local used = #lines[1]
    for i, name in ipairs(names) do
        local add = (i == 1 and "/targetexact " or "/targetexact [noexists][dead] ") .. name
        if used + 1 + #add > budget then break end
        lines[#lines + 1] = add
        used = used + 1 + #add
    end
    if #lines == 1 then return "" end
    lines[#lines + 1] = tail
    return table.concat(lines, "\n")
end

---------------------------------------------------------------------------
-- placement: top-right corner of the step card, by screen position
---------------------------------------------------------------------------
local function place()
    local card = W.UI and W.UI.card
    local panel = W.UI and W.UI.panel
    if not (card and panel and panel:IsShown() and card:GetRight()) then return false end
    b:SetScale(panel:GetEffectiveScale() / UIParent:GetEffectiveScale())
    b:ClearAllPoints()
    -- card and button now share a coordinate scale, so the card's edges can be used directly
    b:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", card:GetRight() + 4, card:GetTop() + 3)
    return true
end

function TG:Sync()
    if InCombatLockdown and InCombatLockdown() then pending = true return end
    pending = false
    local group = W.db.targetButton and G:Group() or {}   -- the steps the card shows
    local names = TG.MobsForGroup(group)
    local macro = TG.BuildMacro(names, W.db.targetMark)
    TG.mobs = {}
    for _, name in ipairs(names) do   -- only what made it into the macro (tooltip honesty)
        if macro:find("/targetexact[^\n]* " .. name:gsub("%p", "%%%0") .. "\n") then TG.mobs[#TG.mobs + 1] = name end
    end
    b:SetAttribute("macrotext", macro)
    local show = #names > 0 and place()
    b:SetShown(show and true or false)
    if W.UI and W.UI.SetCardInset then W.UI.SetCardInset(show and (SIZE + 2) or 0) end
end

---------------------------------------------------------------------------
-- look and tooltip
---------------------------------------------------------------------------
local ACC = W.Skin.ACCENT       -- shared with the theme; read live on hover
W.Skin.Accent(icon, "vertex")
local function themeHover()   -- the button's backdrop follows the theme: circle or square
    if W.Skin.Theme() == "flat" then hover:SetTexture("Interface\\Buttons\\WHITE8x8") else hover:SetTexture(MEDIA .. "circle") end
end
themeHover()
W:On("WF_THEME_CHANGED", themeHover)
b:SetScript("OnEnter", function(self)
    hover:SetVertexColor(ACC[1], ACC[2], ACC[3], 0.28)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Target quest mob")
    for _, name in ipairs(TG.mobs) do GameTooltip:AddLine(name, 0.93, 0.94, 0.96) end
    GameTooltip:AddLine("Bind a key: Key Bindings > AddOns > Sloppy Questing", 0.6, 0.6, 0.6)
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
    b:RegisterForClicks(down and "AnyDown" or "AnyUp")
end

local function sync() TG:Sync() end
W:On("WF_INIT", function() registerClicks() sync() end)
W:On("WF_UPDATED", sync)
W:On("WF_QUEST_STATE", sync)
W:On("WF_SETTINGS_CHANGED", sync)
W:On("WF_RESET_POSITION", sync)
W:On("WF_PANEL_MOVED", sync)
W:On("WF_TOGGLE_PANEL", sync)
W:On("PLAYER_REGEN_ENABLED", function() if pending then sync() end end)
W:On("CVAR_UPDATE", function() if not (InCombatLockdown and InCombatLockdown()) then registerClicks() end end)
