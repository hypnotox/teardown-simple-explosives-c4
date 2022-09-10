function initC4Manager()
    ---@class C4Manager:table
    ---@field placedC4 C4[]
    ---@field explodingC4 C4[]
    C4Manager = {
        placedC4 = {},
        explodingC4 = {},
    }

    function C4Manager:reloadPlaced()
        local alreadyPlantedC4s = FindBodies('hypnotox_explosives_c4')
        local alreadyPlantedC4Attacher = FindShapes('hypnotox_explosives_c4_attacher')

        Debug:dump(alreadyPlantedC4s, 'Already planted C4s')
        Debug:dump(alreadyPlantedC4Attacher, 'Already planted C4 attacher')

        for i = 1, #alreadyPlantedC4s, 1 do
            self:add(C4:fromExisting(alreadyPlantedC4s[i], alreadyPlantedC4Attacher[i]))
        end
    end

    ---C4 manager tick method
    function C4Manager:tick()
        Debug:watch('Planted explosives', #self.placedC4)

        for i = #self.placedC4, 1, -1 do
            self.placedC4[i]:tick()
        end
    end

    ---C4 manager update method
    function C4Manager:update()
        self:detonateNext()
    end

    ---Detonates all currently placed C4, one every update (60 detonations a second)
    function C4Manager:detonate()
        self.explodingC4 = self.placedC4
        self.placedC4 = {}
    end

    ---Detonates next C4
    function C4Manager:detonateNext()
        if #self.explodingC4 > 0 then
            self.explodingC4[1]:detonate()
            table.remove(self.explodingC4, 1)
        end
    end

    ---Detonates C4s inside explosion radius of point
    ---@param pos VectorType
    function C4Manager:detonateClose(pos, maxDist)
        if #self.explodingC4 > 0 then
            self.explodingC4[1]:detonate()
            table.remove(self.explodingC4, 1)
        end
    end

    ---Add new C4 entity to manager
    ---@param c4 C4
    function C4Manager:add(c4)
        table.insert(self.placedC4, c4)
    end
end
