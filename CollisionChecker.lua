local collisionChecker = {}
local utils = require("utils")
local enums = require("enums")
local vector = require("vector")
function collisionChecker.new()
    local self = {}
    function self:CheckTwoObjects(objA, objB)
        --TODO add NIL checks
        --Situations, point collides with a Box, two boxes collide, two points are at the same place
        --TODO add collision check types
        local boxCount = 0
		if objA.CollisionCheckType == enums.CollisionCheckType.box then boxCount = boxCount + 1 end
		if objB.CollisionCheckType == enums.CollisionCheckType.box then boxCount = boxCount + 1 end
        if boxCount == 2 then -- TwoBoxes
            return nil -- ERROR for now, not implemented yet, for future, test if any lines intersect?
        
        elseif boxCount == 1 then
            
            local boxObj, pointObj 
			
			if objA.CollisionCheckType == enums.CollisionCheckType.box then 
				boxObj =  objA 
				pointObj = objB
			else 
				boxObj =  objB
				pointObj = objA
			end
			if pointObj.x >= boxObj:mtrULx() and 
				pointObj.x <= boxObj:mtrURx() and
				pointObj.y <= boxObj:mtrBLy() and 
				pointObj.y >= boxObj:mtrULy() then
				
				return true
			else
				return false
				
			end	
        else
			return nil -- TODO other collision types
		end
   end
   return self
end

return collisionChecker