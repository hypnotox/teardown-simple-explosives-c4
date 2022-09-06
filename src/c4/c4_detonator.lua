function initC4Detonator()
    ---@class C4Detonator:table
    ---@field maxAmmo integer
    ---@field selectedModelIndex integer
    ---@field changeModelKeybind string
    C4Detonator = {
        maxAmmo = 20,
        selectedModelIndex = 1,
        changeModelKeybind = 'o',
    }

    ---@class C4Model:table
    ---@field name string
    ---@field path string
    ---@field scale string
    C4Model = {}

    ---@type table<C4Model>
    local c4Models = {
        {
            name = 'CS:GO Minimal',
            path = 'MOD/src/c4/model/c4_csgo_low.vox',
            scale = '0.25',
        },
        {
            name = 'CS:GO',
            path = 'MOD/src/c4/model/c4_csgo_high.vox',
            scale = '0.125',
        },
        {
            name = 'CS 1.6',
            path = 'MOD/src/c4/model/c4_cs16.vox',
            scale = '0.25',
        },
    }

    local isPicking = false

    ---@param normal VectorType
    ---@return number
    local function getC4RotationFromNormal(normal)
        Debug:dump(normal, 'Normal rotation')
        local _, cameraRotY, _ = GetQuatEuler(GetPlayerCameraTransform().rot)
        local normalX = normal[1]
        local normalY = normal[2]
        local normalZ = normal[3]

        if normalX == 0 and normalY == -1 and normalZ == 0 then
            return cameraRotY
        end

        if normalX == 0 and normalY == 1 and normalZ == 0 then
            return -cameraRotY
        end

        return 0
    end

    ---Initializes C4 detonator
    function C4Detonator:init()
        local modelPath = 'MOD/src/c4/model/c4_detonator.vox'
        local inventorySlot = GetInt('savegame.mod.features.inventory_slot')

        if inventorySlot == 0 then
            inventorySlot = 6
        end
        
        RegisterTool('hypnotox_explosives_c4', 'C4', modelPath, inventorySlot)
        SetBool('game.tool.hypnotox_explosives_c4.enabled', true)
        SetFloat('game.tool.hypnotox_explosives_c4.ammo', self.maxAmmo)

        local lastSelectedIndex = GetInt('savegame.mod.features.last_selected_model')

        if lastSelectedIndex ~= 0 then
            self.selectedModelIndex = lastSelectedIndex
        end

        local changeModelKeybind = GetString('savegame.mod.features.keybinds.change_model')

        if changeModelKeybind ~= '' then
            self.changeModelKeybind = changeModelKeybind
        end
    end

    ---C4 detonator tick method
    function C4Detonator:tick()
        if GetString('game.player.tool') ~= 'hypnotox_explosives_c4' then
            return
        end

        if InputPressed(self.changeModelKeybind) then
            if self.selectedModelIndex == #c4Models then
                self.selectedModelIndex = 1
            else
                self.selectedModelIndex = self.selectedModelIndex + 1
            end

            SetInt('savegame.mod.features.last_selected_model', self.selectedModelIndex)
        end

        local offset = Transform(Vec(0.65, -0.85, -1.7), QuatEuler(-6, 37, -10))
        SetToolTransform(offset, 0.2)

        if InputPressed(Input.lmb) and GetPlayerVehicle() == 0 then
            local player = GetPlayerCameraTransform()
            local fwd = TransformToParentVec(player, Vec(0, 0, -1))
            local hit, dist, normal, shape = QueryRaycast(player.pos, fwd, 5)

            if hit then
                local pos = TransformToParentPoint(player, Vec(0, 0, -(dist - 0.02)))
                local rot = QuatLookAt(pos, VecAdd(pos, normal))
                rot = QuatRotateQuat(rot, QuatEuler(0, 0, getC4RotationFromNormal(normal)))

                local c4 = C4:new(Transform(pos, rot), shape, c4Models[self.selectedModelIndex])
                C4Manager:add(c4)
            end
        end

        if InputPressed(Input.rmb) then
            local body = GetPlayerPickBody()

            if body == 0 then
                C4Manager:detonate()
            else
                isPicking = true
            end
        end

        Debug:watch('isPicking', isPicking)

        if InputDown(Input.rmb) and not isPicking then
            SetShapeEmissiveScale(self:getButtonShape(), 1)
        else
            SetShapeEmissiveScale(self:getButtonShape(), 0)
        end

        if InputReleased(Input.rmb) then
            isPicking = false
        end
    end

    ---C4 detonator update method
    function C4Detonator:update()
        
    end

    ---C4 detonator draw method
    function C4Detonator:draw()
        if GetString('game.player.tool') ~= 'hypnotox_explosives_c4' then
            return
        end

        UiPush()
        UiTranslate(10, UiHeight() - 10)
        UiAlign('bottom left')
        UiFont('regular.ttf', 24)
        UiText(c4Models[self.selectedModelIndex].name)
        UiPop()
    end

    function C4Detonator:getButtonShape()
        local body = GetToolBody()

        return GetBodyShapes(body)[2]
    end
end
