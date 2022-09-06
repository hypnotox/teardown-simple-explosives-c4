---@class Options
---@field valueToSet string?
---@field inputBuffer number|string|nil
Options = {
    keyToSet = nil,
    inputBuffer = nil,
}

function init()
    local isInitialized = GetBool('savegame.mod.general.is_initialized')

    if not isInitialized then
        SetString('savegame.mod.features.keybinds.change_model', 'O')

        SetBool('savegame.mod.general.is_initialized', true)
    end
end

function draw()
    UiTranslate(UiCenter(), 50)
    UiAlign('center middle')
    UiFont('regular.ttf', 24)

    --Title
    UiPush()
    UiFont('bold.ttf', 48)
    UiText('Simple Explosives - C4 mod options')
    UiPop()
    UiTranslate(0, 100)

    -- Subtitle nozzle
    Options:subtitle('Keybinds')
    Options:value('Change selected model', 'savegame.mod.features.keybinds.change_model')

    -- Inventory slot
    Options:subtitle('Inventory slot')
    Options:value('Set inventory slot (1-6)', 'savegame.mod.features.inventory_slot', 6, true)

    UiTranslate(0, 100)
    if UiTextButton('Close', 200, 40) then
        Menu()
    end
end

function Options:title(title)
    UiPush()
    UiFont('bold.ttf', 48)
    UiText(title)
    UiPop()
    UiTranslate(0, 100)
end

function Options:subtitle(title)
    UiPush()
    UiFont('bold.ttf', 36)
    UiText(title)
    UiPop()
    UiTranslate(0, 100)
end

---@param title string
---@param key string
---@param default number|string|nil
---@param isInventorySlot boolean|nil
function Options:value(title, key, default, isInventorySlot)
    UiPush()
    UiFont('regular.ttf', 26)

    UiPush()
    UiTranslate(-200, 0)
    UiText(title)
    UiPop()

    UiPush()
    UiTranslate(200, 0)

    ---@type string|number|nil
    local value = GetString(key)

    if value == '' then
        value = default
    end

    if value and value ~= nil then
        UiPush()
        UiColor(0.5, 1, 0.5, 0.2)
        UiImageBox('ui/common/box-solid-6.png', 200, 40, 6, 6)
        UiPop()
    end

    if self.keyToSet == key then
        UiButtonImageBox('ui/common/box-outline-6.png', 6, 6)
    end

    if UiTextButton(tostring(value) or 'not bound', 200, 40) then
        self.keyToSet = key
    end
    UiPop()

    UiPop()
    UiTranslate(0, 100)

    local lastPressedKey = InputLastPressedKey()
    if self.keyToSet == key and lastPressedKey ~= '' then
        local number = tonumber(lastPressedKey)

        if isInventorySlot == true and (number == nil or number == 0 or number > 6) then
            return
        end

        SetString(self.keyToSet, lastPressedKey)
        self.keyToSet = nil
    end
end

function Options:toggle(title, key, default)
    default = default or false
    UiPush()

    UiPush()
    UiTranslate(-200, 0)
    UiText(title)
    UiPop()

    UiPush()
    UiTranslate(200, 0)
    UiButtonImageBox('ui/common/box-outline-6.png', 6, 6)
    local label = 'Off'

    if GetBool(key) or default then
        UiPush()
        UiColor(0.5, 1, 0.5, 0.2)
        UiImageBox('ui/common/box-solid-6.png', 80, 40, 6, 6)
        UiPop()
        label = 'On'
    end

    if UiTextButton(label, 80, 40) then
        SetBool(key, not GetBool(key))
    end
    UiPop()

    UiPop()
    UiTranslate(0, 100)
end

function Options:input(title, key)
    UiPush()
    UiFont('regular.ttf', 26)

    UiPush()
    UiTranslate(-200, 0)
    UiText(title)
    UiPop()

    UiPush()
    UiTranslate(200, 0)
    local value = GetString(key)

    if value and value ~= nil then
        UiPush()
        UiColor(0.5, 1, 0.5, 0.2)
        UiImageBox('ui/common/box-solid-6.png', 200, 40, 6, 6)
        UiPop()
    end

    if Options.keyToSet == key then
        UiButtonImageBox('ui/common/box-outline-6.png', 6, 6)
    end

    if UiTextButton(tostring(GetInt(key)), 200, 40) then
        Options.keyToSet = key
    end
    UiPop()

    UiPop()
    UiTranslate(0, 100)

    local lastPressedKey = InputLastPressedKey()
    if Options.keyToSet == key and lastPressedKey ~= '' then
        if lastPressedKey == 'enter' then
            Options.keyToSet = nil
            local inputBuffer = Options.inputBuffer
            SetString(Options.keyToSet, tostring(inputBuffer))
        else
            Options.inputBuffer = Options.inputBuffer .. lastPressedKey
        end
    end
end
