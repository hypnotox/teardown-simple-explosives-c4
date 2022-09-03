function initC4Detonator()
    ---@class C4Detonator:table
    ---@field maxAmmo integer
    C4Detonator = {
        maxAmmo = 20,
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
        
        RegisterTool('hypnotox_explosives_c4', 'C4', modelPath, 6)
        SetBool('game.tool.hypnotox_explosives_c4.enabled', true)
        SetFloat('game.tool.hypnotox_explosives_c4.ammo', self.maxAmmo)
    end

    ---C4 detonator tick method
    function C4Detonator:tick()
        if GetString('game.player.tool') ~= 'hypnotox_explosives_c4' then
            return
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

                C4Manager:add(C4:new(Transform(pos, rot), shape))
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

    function C4Detonator:getButtonShape()
        local body = GetToolBody()

        return GetBodyShapes(body)[2]
    end
end
