local mod = RegisterMod("Equity - Improve Curses", 1)

local RECOMMENDED_SHIFT_IDX = 35
local CURSE_PROBABILITY = 5

local CURSES = {
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_BLIND,
    LevelCurse.CURSE_OF_LABYRINTH,
    LevelCurse.CURSE_OF_THE_LOST,
    LevelCurse.CURSE_OF_THE_UNKNOWN,
    LevelCurse.CURSE_OF_THE_CURSED,
    LevelCurse.CURSE_OF_MAZE
}

mod.random = {}
mod.random.curses = RNG()

local function setCustomCurses()

    local level = Game():GetLevel()

    local rg_init = 0
    local rg_end = 0

    local c = mod.random.curses:RandomInt(100)

    for _, curse in ipairs(CURSES) do
        level:RemoveCurses(curse)
    end

    for _, curse in ipairs(CURSES) do

        rg_init = rg_end
        rg_end = rg_init + CURSE_PROBABILITY

        if rg_init <= c and c < rg_end then
            level:AddCurse(curse)
            Isaac.DebugString("Applied Curse: " .. tostring(curse))
            return
        end
    end

    Isaac.DebugString("No Curse Applied")

end

-- Initialize random seeds
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(isContinued)

    if isContinued then
        return
    end

    for _, rng in pairs(mod.random) do
        rng:SetSeed(Game():GetSeeds():GetStartSeed(), RECOMMENDED_SHIFT_IDX)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, setCustomCurses)