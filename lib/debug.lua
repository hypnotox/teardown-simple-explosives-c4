function initDebug()
    Debug = {
        enabled = false,
        toggleKey = Input.home,
        isExtraDebugInfoEnabled = true,
    }

    local function dumpTransform(transform)
        local t = TransformCopy(transform)
        local x, y, z = GetQuatEuler(t.rot)
        t.rot = {x, y, z}

        return Debug:dumpString(t)
    end

    function Debug:init()
        self.enabled = GetBool('savegame.mod.features.debug.enabled') or false

        if not self.enabled then
            return
        end

        self:print('Debug enabled')
    end

    function Debug:tick()
        if InputPressed(self.toggleKey) then
            self.enabled = not self.enabled
        end

        if InputPressed(Input.pgUp) then
            self.isExtraDebugInfoEnabled = not self.isExtraDebugInfoEnabled
        end

        if not self.enabled then
            return
        end

        local playerTransform = GetCameraTransform()
        local cameraTransform = GetCameraTransform()

        self:watch('player', dumpTransform(playerTransform))
        self:watch('camera', dumpTransform(cameraTransform))

        if not self.isExtraDebugInfoEnabled then
            return
        end

        -- Tool
        local tool = GetToolBody()
        local toolTransform = GetBodyTransform(tool)
        self:watch('tool', dumpTransform(toolTransform))

        --Raycast forwards
        local dir = TransformToParentVec(cameraTransform, {0, 0, -1})
        local hit, dist, normal, shape = QueryRaycast(cameraTransform.pos, dir, 10)

        if hit then
            --Visualize raycast hit and normal
            local hitPoint = VecAdd(cameraTransform.pos, VecScale(dir, dist))
            self:line(VecAdd(cameraTransform.pos, {0, -1, 0}), hitPoint, 0, 1, 0)
            self:line(hitPoint, VecAdd(hitPoint, normal), 1, 0, 0)
            self:shapeOutline(shape, 1)
            self:watch('Point', hitPoint[1] .. ', ' .. hitPoint[2] .. ', ' .. hitPoint[3])
            self:watch('Shape', tostring(shape))
        end
    end

    -- Debug functions --

    function Debug:line(p0, p1, r, g, b, a)
        if not self.enabled then
            return
        end

        DebugLine(p0, p1, r or 255, g or 255, b or 255, a or 1)
    end

    function Debug:cross(p0, r, g, b, a)
        if not self.enabled then
            return
        end

        DebugCross(p0, r or 255, g or 255, b or 255, a or 1)
    end

    function Debug:watch(name, value)
        if not self.enabled then
            return
        end

        DebugWatch(name, value)
    end

    function Debug:print(message)
        if not self.enabled then
            return
        end

        DebugPrint(message)
    end

    -- Body and shape functions --

    function Debug:bodyOutline(handle, a)
        if not self.enabled then
            return
        end

        DrawBodyOutline(handle, a or 1)
    end

    function Debug:bodyOutline(handle, r, g, b, a)
        if not self.enabled then
            return
        end

        DrawBodyOutline(handle, r or 255, g or 255, b or 255, a or 1)
    end

    function Debug:bodyHighlight(handle, amount)
        if not self.enabled then
            return
        end

        DrawShapeHighlight(handle, amount)
    end

    function Debug:shapeOutline(handle, a)
        if not self.enabled then
            return
        end

        DrawBodyOutline(handle, a or 1)
    end

    function Debug:shapeOutline(handle, r, g, b, a)
        if not self.enabled then
            return
        end

        DrawShapeOutline(handle, r or 255, g or 255, b or 255, a or 1)
    end

    function Debug:shapeHighlight(handle, amount)
        if not self.enabled then
            return
        end

        DrawShapeHighlight(handle, amount)
    end

    -- Other dump functions --

    -- Used to dump a variable onto screen
    function Debug:dump(object, title)
        if title then
            self:print(title .. ': ' .. self:dumpString(object))
        else
            self:print(self:dumpString(object))
        end
    end

    function Debug:dumpString(object)
        if object == nil then
            return 'nil'
        end

        if (type(object) == 'number') or (type(object) == 'string') or (type(object) == 'boolean') then
            return tostring(object)
        end

        local toDump = '{'

        for k, v in pairs(object) do
            if (type(k) == 'number') then
                toDump = toDump .. '[' .. k .. '] = '
            elseif (type(k) == 'string') then
                toDump = toDump .. k ..  '= '
            end

            if (type(v) == 'number') then
                toDump = toDump .. v .. ','
            elseif (type(v) == 'string') then
                toDump = toDump .. '\'' .. v .. '\', '
            else
                toDump = toDump .. self:dumpString(v) .. ', '
            end
        end

        toDump = toDump .. '}'

        return toDump
    end
end
