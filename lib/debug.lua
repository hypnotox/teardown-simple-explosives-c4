function initDebug()
    ---@class Debug:table
    ---@field toggleKey string
    ---@field isEnabled boolean
    ---@field toggleExtraInfoKey string
    ---@field isExtraDebugInfoEnabled boolean
    Debug = {
        toggleKey = Input.home,
        isEnabled = false,
        toggleExtraInfoKey = Input.endKey,
        isExtraDebugInfoEnabled = false,
    }

    function Debug:init()
        self.isEnabled = true
    end

    function Debug:tick()
        if not self.isEnabled then
            return
        end

        local playerTransform = GetPlayerTransform()
        local cameraTransform = GetCameraTransform()
        local toolTransform = GetBodyTransform(GetToolBody())

        local dir = TransformToParentVec(cameraTransform, {0, 0, -1})
        local hit, dist, normal, _ = QueryRaycast(cameraTransform.pos, dir, 10)

        if hit then
            local hitPoint = VecAdd(cameraTransform.pos, VecScale(dir, dist))
            local hitTransform = Transform(hitPoint, QuatLookAt(hitPoint, VecAdd(hitPoint, normal)))
            self:line(hitPoint, TransformToParentPoint(hitTransform, Vec(-1, 0, 0)), 0, 1, 0)
            self:line(hitPoint, TransformToParentPoint(hitTransform, Vec(0, 1, 0)), 0, 0, 1)
            self:line(hitPoint, TransformToParentPoint(hitTransform, Vec(0, 0, -1)), 1, 0, 0)
        end

        self:watch('player position', self:toString(playerTransform.pos))
        self:watch('camera rotation', self:toString(Vec(GetQuatEuler(playerTransform.rot))))
        self:watch('camera position', self:toString(cameraTransform.pos))
        self:watch('camera rotation', self:toString(Vec(GetQuatEuler(cameraTransform.rot))))
        self:watch('tool position', self:toString(toolTransform.pos))
        self:watch('tool rotation', self:toString(Vec(GetQuatEuler(toolTransform.rot))))
    end

    -- Debug functions --

    ---@param p0 VectorType World space point as vector
    ---@param p1 VectorType World space point as vector
    ---@param r number|nil Red
    ---@param g number|nil Green
    ---@param b number|nil Blue
    ---@param a number|nil Alpha
    ---@see @https://www.teardowngame.com/modding/api.html#DebugLine
    function Debug:line(p0, p1, r, g, b, a)
        if not self.isEnabled then
            return
        end

        DebugLine(p0, p1, r or 255, g or 255, b or 255, a or 1)
    end

    ---@param p0 VectorType World space point as vector
    ---@param r number|nil Red
    ---@param g number|nil Green
    ---@param b number|nil Blue
    ---@param a number|nil Alpha
    ---@see @https://www.teardowngame.com/modding/api.html#DebugCross
    function Debug:cross(p0, r, g, b, a)
        if not self.isEnabled then
            return
        end

        DebugCross(p0, r or 255, g or 255, b or 255, a or 1)
    end

    ---@param name string Name
    ---@param value string|number|boolean Value
    ---@see @https://www.teardowngame.com/modding/api.html#DebugWatch
    function Debug:watch(name, value)
        if not self.isEnabled then
            return
        end

        DebugWatch(name, tostring(value))
    end

    ---@param message string Message to display
    ---@see @https://www.teardowngame.com/modding/api.html#DebugPrint
    function Debug:print(message)
        if not self.isEnabled then
            return
        end

        DebugPrint(message)
    end

    -- Body and shape functions --

    ---@param handle integer Body handle
    ---@param a number Alpha
    ---@see @https://www.teardowngame.com/modding/api.html#DrawBodyOutline
    function Debug:bodyOutline(handle, a)
        if not self.isEnabled then
            return
        end

        DrawBodyOutline(handle, a or 1)
    end

    ---@param handle integer Body handle
    ---@param r number Red
    ---@param g number Green
    ---@param b number|nil Blue
    ---@param a number|nil Alpha
    ---@see @https://www.teardowngame.com/modding/api.html#DrawBodyOutline
    function Debug:bodyOutline(handle, r, g, b, a)
        if not self.isEnabled then
            return
        end

        DrawBodyOutline(handle, r or 255, g or 255, b or 255, a or 1)
    end

    ---@param handle integer Shape handle
    ---@param amount number Amount
    ---@see @https://www.teardowngame.com/modding/api.html#DrawShapeHighlight
    function Debug:bodyHighlight(handle, amount)
        if not self.isEnabled then
            return
        end

        DrawBodyHighlight(handle, amount)
    end

    ---@param handle integer Shape handle
    ---@param a number Alpha
    ---@see @https://www.teardowngame.com/modding/api.html#DrawShapeOutline
    function Debug:shapeOutline(handle, a)
        if not self.isEnabled then
            return
        end

        DrawShapeOutline(handle, a or 1)
    end

    ---@param handle integer Shape handle
    ---@param r number|nil Red
    ---@param g number|nil Green
    ---@param b number|nil Blue
    ---@param a number Alpha
    ---@see @https://www.teardowngame.com/modding/api.html#DrawShapeOutline
    function Debug:shapeOutline(handle, r, g, b, a)
        if not self.isEnabled then
            return
        end

        DrawShapeOutline(handle, r or 255, g or 255, b or 255, a or 1)
    end

    ---@param handle integer Shape handle
    ---@param amount number Amount
    ---@see @https://www.teardowngame.com/modding/api.html#DrawShapeHighlight
    function Debug:shapeHighlight(handle, amount)
        if not self.isEnabled then
            return
        end

        DrawShapeHighlight(handle, amount)
    end

    -- Other dump functions --

    ---Used to dump a variable onto screen
    ---@param object any
    ---@param title string
    function Debug:dump(object, title)
        if title then
            self:print(title .. ': ' .. self:toString(object))
        else
            self:print(self:toString(object))
        end
    end

    ---Get object in printable format
    ---@param object any
    ---@return string
    function Debug:toString(object)
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
                toDump = toDump .. self:toString(v) .. ', '
            end
        end

        toDump = toDump .. '}'

        return toDump
    end
end
