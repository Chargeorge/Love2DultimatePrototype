local collisionChecker = {}
local utils = require("utils")
local enums = require("enums")
local vector = require("vector")
local boundingBox = require("boundingbox")
function collisionChecker.new()
    local self = {}
    
    function self:boxBoxCollision(boxA, boxB)

		if(boxA:left() <= boxB:right() and 
				boxB:left() <= boxA:right() and
				boxA:top() <= boxB:bottom() and
				boxB:top() <= boxA:bottom()
				) then
					print ("BoxA Left " ..boxA:left() .. " BoxA Right: " .. boxA:right() .. " boxA Top: " .. boxA:top() .. " boxa bottom " .. boxA:bottom())
					
					print ("boxB Left " ..boxB:left() .. " boxB Right: " .. boxB:right() .. " boxB Top: " .. boxB:top() .. " boxB bottom " .. boxB:bottom())
				end
			
				
		
		return (boxA:left() <= boxB:right() and 
				boxB:left() <= boxA:right() and
				boxA:top() <= boxB:bottom() and
				boxB:top() <= boxA:bottom()
				)

	end
    function self:CheckTwoObjects(objA, objB)
        --TODO add NIL checks
        --Situations, point collides with a Box, two boxes collide, two points are at the same place
        --TODO add collision check types
        local boxCount = 0
		if objA.CollisionCheckType == enums.CollisionCheckType.box then boxCount = boxCount + 1 end
		if objB.CollisionCheckType == enums.CollisionCheckType.box then boxCount = boxCount + 1 end
        if boxCount == 2 then -- TwoBoxes
            
			
			return self:boxBoxCollision(objA, objB)
        elseif boxCount == 1 then
            
            local boxObj, pointObj 
			
			if objA.CollisionCheckType == enums.CollisionCheckType.box then 
				boxObj =  objA 
				pointObj = objB
			else 
				boxObj =  objB
				pointObj = objA
			end
			if self:boxPointCollision(boxObj, pointObj) then
				
				return true
			else
				return false
				
			end	
        else
			return nil -- TODO other collision types
		end
   end
   
	function self:boxPointCollision(boxObj, pointObj)
		return (pointObj.x >= boxObj:mtrULx() and 
			pointObj.x <= boxObj:mtrURx() and
			pointObj.y <= boxObj:mtrBLy() and 
			pointObj.y >= boxObj:mtrULy())
	end
	

   
   return self
end

return collisionChecker