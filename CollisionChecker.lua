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
        boxCount += (objA.CollisionCheckType == enums.CollisionCheckType.box) and 1 or 0;
        boxCount += (objB.CollisionCheckType == enums.CollisionCheckType.box) and 1 or 0;
        if boxCount = 2 then -- TwoBoxes
            return nil -- ERROR for now, not implemented yet, for future, test if any lines intersect?
        end
        else if boxCount = 1 then
            
            local boxObj, pointObj 
			
			if objA.CollisionCheckType == enums.CollisionCheckType.box then 
				boxObj =  objA 
				pointObj = objB
			else 
				boxObj =  objB
				pointObj = objA
			end
			if pointObj.x >= boxObj:metULx() and 
				pointObj.x <= boxObj:metURx() and
				pointObj.y <= boxObj:metBLy() and 
				pointObj.y >= boxObj:metULy() then
				
				return true
			else
				return false
				
			end	
        else
			return nil -- TODO other collision types
		end
   end
end

return collisionChecker