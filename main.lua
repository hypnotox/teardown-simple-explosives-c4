--[[
-- Libraries
#include "lib/input.lua"
#include "lib/debug.lua"

-- C4
#include "c4/c4_detonator.lua"
#include "c4/c4_manager.lua"
#include "c4/c4.lua"
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

function tick(dt)
    if not initialized then
        initializeDependencies()
    end

    Debug:tick(dt)
    C4Manager:tick(dt)
    C4Detonator:tick(dt)
end

function update(dt)
    if not initialized then
        initializeDependencies()
    end

    C4Manager:update(dt)
    C4Detonator:update(dt)
end
