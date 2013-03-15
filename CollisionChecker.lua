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
        boxCount += (objA.CollisionCheckType == enums.CollisionCheckType.box) ? 1 :0;
        boxCount += (objB.CollisionCheckType == enums.CollisionCheckType.box) ? 1 :0;
        if boxCount = 2 then -- TwoBoxes
            return nil -- ERROR for now, not implemented yet, for future, test if any lines intersect?
        end
        else if boxCount = 1 then
           
            local boxObj = (objA.CollisionCheckType == enums.CollisionCheckType.box) ? objA : objB
            
        else
        
   end
end

return collisionChecker