function initC4()
    ---@class C4:table
    ---@field shape integer
    ---@field pos VectorType
    C4 = {}

    ---Creates new C4 entity
    ---@param transform TransformType
    ---@param attachShape number
    ---@return C4
    function C4:new(transform, attachShape)
        local body = GetShapeBody(attachShape)
        local isBodyDynamic = IsBodyDynamic(body)
        local shapeIndex = isBodyDynamic and 2 or 1
        local shape = Spawn('MOD/prefabs/c4.xml', transform, not isBodyDynamic, true)[shapeIndex]

        local instance = {
            shape = shape,
        }

        setmetatable(instance, self)
        self.__index = self
        return instance
    end

    ---Detonates the entity
    function C4:detonate()
        local otherExplosives = nil

        Explosion(self.pos, 2.0)
    end

    ---C4 tick method
    function C4:tick()
        local center = self:getCenter()

        if center[1] == 0 and center[2] == 0 and center[3] == 0 then
            return
        end

        self.pos = center
    end

    ---Get center of C4 shape
    ---@return VectorType
    function C4:getCenter()
        local boundsMin, boundsMax = GetShapeBounds(self.shape)
        
        return VecLerp(boundsMin, boundsMax, 0.5)
    end
end
