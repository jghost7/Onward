-- Onward core: namespace, saved variables, event bus, debounced refresh, slash commands.
local ADDON, W = ...
_G.Onward = W

-- the TOC's "## Version" is the only place the version is written (tools/package.py bumps it)
local getMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
W.version = (getMeta and getMeta(ADDON, "Version")) or "dev"

local DEFAULTS = {
    -- questing
    questMode = "efficient", -- all | efficient (skip clear time sinks) | fastest (best XP/hour)
    groupQuests = "show",    -- show | hide: elite, dungeon and group-only quests (marked on the panel when shown)
    autoAccept = true,       -- accept quests the active guide asks for
    autoAcceptAll = false,   -- accept every quest offered, guide or not
    autoTurnIn = true,       -- turn in quests that are ready (single reward only)
    -- navigation
    arrow = true,            -- Onward's nav arrow
    arrowScale = 1,
    arrowLocked = false,
    arrowPoint = nil,
    waypoints = true,        -- Blizzard map pin on the current step
    tomtom = true,           -- also a TomTom waypoint when TomTom is installed
    routeMode = "next",      -- travel route on the world map: off | current | next
    routeStops = 3,          -- how many steps past the current one "next" shows
    targetButton = true,     -- crosshair on kill/loot steps that targets the nearest quest mob
    targetMark = true,       -- put a skull on the mob it targets
    -- travel
    travelAdvice = true,     -- suggest flights when they beat running
    autoTaxi = true,         -- pick the flight at the flight master (hold Shift to choose yourself)
    -- panel
    showNext = 3,            -- upcoming steps shown under the current one
    showObjectives = true,
    showParty = true,
    dropStats = true,        -- your drop rate vs the expected one under item objectives
    theme = "flat",          -- flat (Ellesmere-style) | glass
    bgAlpha = 0.85,          -- panel opacity
    scale = 1,
    locked = false,
    collapsed = false,
    fadeInCombat = false,
    point = nil,             -- saved frame position
    -- party
    partySync = true,        -- send/receive step + quest state with party members
    partyToasts = true,      -- "Alex finished X" pop-ups
    partyChat = false,       -- also announce "done" in party chat (for people without the addon)
}
W.DEFAULTS = DEFAULTS

local CHAR_DEFAULTS = {
    guide = "smart",         -- active guide id ("smart" = built from your quest log)
    skipped = {},            -- [guideId] = { [stepIndex] = true }
    recording = nil,         -- recorder session in progress
}

local function applyDefaults(dst, src)
    for k, v in pairs(src) do
        if dst[k] == nil then
            if type(v) == "table" then dst[k] = {} applyDefaults(dst[k], v) else dst[k] = v end
        end
    end
    return dst
end

-- issecretvalue exists on Midnight-era clients; values it flags must not be compared or stored.
function W.Safe(v)
    if v == nil then return nil end
    if issecretvalue and issecretvalue(v) then return nil end
    return v
end

function W.Print(...)
    print("|c" .. (W.Skin and W.Skin.AccentHex() or "ff0cd29d") .. "Onward|r", ...)
end

---------------------------------------------------------------------------
-- Event bus: modules call W:On(event, fn). One frame, one dispatch table.
---------------------------------------------------------------------------
local frame = CreateFrame("Frame")
local handlers = {}

function W:On(event, fn)
    if not handlers[event] then
        handlers[event] = {}
        -- custom (non-game) events are prefixed WF_ and never registered with the client
        if not event:find("^WF_") then frame:RegisterEvent(event) end
    end
    table.insert(handlers[event], fn)
end

function W:Fire(event, ...)
    local list = handlers[event]
    if not list then return end
    for i = 1, #list do
        local ok, err = pcall(list[i], event, ...)
        if not ok then geterrorhandler()(err) end
    end
end

frame:SetScript("OnEvent", function(_, event, ...) W:Fire(event, ...) end)

---------------------------------------------------------------------------
-- Debounced refresh: many quest events arrive in bursts (QUEST_LOG_UPDATE
-- fires several times per kill). Everything that re-evaluates the guide goes
-- through W:RequestRefresh(), which coalesces into one pass per frame batch.
---------------------------------------------------------------------------
local refreshPending = false
function W:RequestRefresh(delay)
    if refreshPending then return end
    refreshPending = true
    C_Timer.After(delay or 0.1, function()
        refreshPending = false
        W:Fire("WF_REFRESH")
    end)
end

---------------------------------------------------------------------------
-- Startup
---------------------------------------------------------------------------
W:On("ADDON_LOADED", function(_, name)
    if name ~= ADDON then return end
    OnwardDB = applyDefaults(OnwardDB or {}, DEFAULTS)
    OnwardCharDB = applyDefaults(OnwardCharDB or {}, CHAR_DEFAULTS)
    W.db, W.cdb = OnwardDB, OnwardCharDB
    W:Fire("WF_INIT")
end)

W:On("PLAYER_ENTERING_WORLD", function()
    W:RequestRefresh(0.5)
end)

---------------------------------------------------------------------------
-- Slash commands
---------------------------------------------------------------------------
local HELP = {
    "/ow (or /onward)  - show or hide the guide panel",
    "/ow guides  - pick a guide",
    "/ow suggest  - switch to the guide that suits your level, race and quest log",
    "/ow prof  - profession guides (1-300 for every profession)",
    "/ow options  - settings",
    "/ow arrow  - show or hide the nav arrow (/ow arrow debug: what it's pointing from and to)",
    "/ow mode all | efficient | fastest  - which quests the guides include",
    "/ow group show | hide  - elite and dungeon quests in the guides",
    "/ow next | prev  - skip or go back one step",
    "/ow rec start | stop | show  - record a route as you play",
    "/ow auto  - toggle auto accept / turn-in",
    "/ow party  - toggle party sync",
    "/ow drops [reset | debug]  - your quest-item drop rates vs the expected ones",
    "/ow reset  - reset panel position",
}

SLASH_ONWARD1 = "/ow"
SLASH_ONWARD2 = "/onward"
SLASH_ONWARD3 = "/sq"   -- the old Sloppy Questing command, kept for a while after the rename
SlashCmdList.ONWARD = function(msg)
    local cmd, rest = (msg or ""):match("^%s*(%S*)%s*(.-)%s*$")
    cmd = cmd:lower()
    if cmd == "" then
        W:Fire("WF_TOGGLE_PANEL")
    elseif cmd == "guides" or cmd == "g" then
        W:Fire("WF_SHOW_PICKER", "zones")
    elseif cmd == "suggest" or cmd == "recommend" then
        W.cdb.pickedSmart = nil
        W.Guide:StartRecommended()
    elseif cmd == "prof" or cmd == "professions" then
        W:Fire("WF_SHOW_PICKER", "professions")
    elseif cmd == "options" or cmd == "config" or cmd == "o" then
        W:Fire("WF_SHOW_OPTIONS")
    elseif cmd == "mode" then
        local m = rest:lower()
        if m == "all" or m == "efficient" or m == "fastest" then
            W.db.questMode = m
            W.Guide:Reload()
            W:Fire("WF_SETTINGS_CHANGED")
        end
        W.Print("quest mode:", W.db.questMode, "(all | efficient | fastest)")
    elseif cmd == "group" or cmd == "elite" then
        local m = rest:lower()
        if m == "show" or m == "hide" then
            W.db.groupQuests = m
            W.Guide:Reload()
            W:Fire("WF_SETTINGS_CHANGED")
        end
        W.Print("group quests:", W.db.groupQuests, "(show | hide)")
    elseif cmd == "arrow" then
        if rest:lower() == "debug" then W.Arrow:Debug() else W.Arrow:Toggle() end
    elseif cmd == "next" then
        W.Guide:Skip(1)
    elseif cmd == "prev" then
        W.Guide:Skip(-1)
    elseif cmd == "rec" then
        W.Recorder:Command(rest)
    elseif cmd == "auto" then
        W.db.autoAccept = not W.db.autoAccept
        W.db.autoTurnIn = W.db.autoAccept
        W.Print("auto accept / turn-in", W.db.autoAccept and "on" or "off", "(hold Shift at an NPC to pause it)")
    elseif cmd == "party" then
        W.db.partySync = not W.db.partySync
        W.Print("party sync", W.db.partySync and "on" or "off")
    elseif cmd == "drops" then
        local sub = rest:lower()
        if sub == "reset" then W.Drops:Reset() elseif sub == "debug" then W.Drops:Debug() else W.Drops:Report() end
    elseif cmd == "reset" then
        W.db.point = nil
        W.db.arrowPoint = nil
        W:Fire("WF_RESET_POSITION")
    elseif cmd == "debug" then
        W.debug = not W.debug
        W.Print("debug", W.debug and "on" or "off")
    else
        for _, line in ipairs(HELP) do W.Print(line) end
    end
end

function W.Debug(...)
    if W.debug then W.Print("|cff888888[debug]|r", ...) end
end
