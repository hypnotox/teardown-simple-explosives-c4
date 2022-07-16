--[[
-- Libraries
#include "scripts/lib/input.lua"
#include "scripts/lib/debug.lua"

-- C4
#include "scripts/c4/c4_detonator.lua"
#include "scripts/c4/c4_manager.lua"
#include "scripts/c4/c4.lua"
]]

local initialized = false

local function initializeDependencies()
    initInput()
    initDebug()
    initC4()
    initC4Manager()
    initC4Detonator()
    initialized = true
end

function init()
    initializeDependencies()
    Debug:init() -- Must be disabled when publishing
    C4Detonator:init()
end

function tick()
    if not initialized then
        initializeDependencies()
    end

    Debug:tick()
    C4Manager:tick()
    C4Detonator:tick()
end

function update()
    if not initialized then
        initializeDependencies()
    end

    C4Manager:update()
    C4Detonator:update()
end
