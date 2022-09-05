function initC4()
    ---@class C4:table
    ---@field attacher integer
    ---@field body integer
    ---@field center VectorType
    C4 = {}

    ---Creates new C4 entity
    ---@param transform TransformType
    ---@param attachShape integer
    ---@param model C4Model
    ---@return C4
    function C4:new(transform, attachShape, model)
        local attachBody = GetShapeBody(attachShape)
        local isBodyDynamic = IsBodyDynamic(attachBody)
        local attacherIndex = isBodyDynamic and 2 or 1
        local attacher = Spawn('MOD/src/model/attacher.xml', transform, not isBodyDynamic, true)[attacherIndex]
        local body = Spawn(
            '<vox pos="0.0 -0.2 -0.05" file="' .. model.path .. '" scale="' .. model.scale .. '"/>', 
            transform
        )[1]

        local instance = {
            attacher = attacher,
            body = body,
        }

        setmetatable(instance, self)
        self.__index = self
        self:align()

        return instance
    end

    ---Detonates the entity
    function C4:detonate()
        Explosion(self.center, 2.0)
        Delete(self.body)
    end

    ---C4 tick method
    function C4:tick()
        local center = self:getCenter()
        self:align()

        if center[1] == 0 and center[2] == 0 and center[3] == 0 then
            return
        end

        self.center = center
    end

    function C4:align()
        local attacherTransform = GetShapeWorldTransform(self.attacher)
        attacherTransform.pos = TransformToParentPoint(attacherTransform, Vec(0.11, -0.1, 0.03))
        SetBodyTransform(self.body, attacherTransform)
    end

    ---Get center of C4 shape
    ---@return VectorType
    function C4:getCenter()
        local boundsMin, boundsMax = GetShapeBounds(self.attacher)

        return VecLerp(boundsMin, boundsMax, 0.5)
    end
end
