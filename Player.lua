local player = {}
local utils = require("utils")
local enums = require("enums")
local vector = require("vector")
local collisionChecker = require("collisionChecker")
function player.new()
	local self = {}
	local utilHandler = utils.new()
	local collisionCheck = collisionChecker:new()
	self.x  = 40 -- need to create a coordinate system
	self.y = 40 
	self.side = .8;
	self.front = 1.2;
	self.angle = 0;
	self.z = 0 -- Z is the bottom of the foot
	self.height = 0 -- height to head
	self.armLen = 0-- length of arm
	self.playerId = math.random(1, 1000000) --TODO: Need to take a look at this, and ensure no collisions.
	self.waypointlist = {}
	self.isselected = false
	self.currentAction = enums.NextAction.standStill
	self.mtrsMovementVector = vector.new(0, 0,0)
	
	--Stats
	self.mtrsMaxSpeed = 4
	self.mtrssMaxAccel = 2
	self.mtrssMaxDeccel = 8
	self.radsMaxRotate = math.pi*2
	--print (utilHandler:TranslateXMeterToPixel(self.x))
	
	--Internals
	self.CollisionCheckType = enums.CollisionCheckType.box
	
	function self:GetPixelX()
		return utilHandler:TranslateXMeterToPixel(self.x)
	
	end
	
	function self:GetPixelY()
		return utilHandler:TranslateYMeterToPixel(self.y)
	end
	
	function self:GetFrontPixel()
		return utilHandler:TD(self.front)
	end
	
	function self:GetSidePixel()
		return utilHandler:TD(self.side)
	end
	
	
	function self:draw()
		
		if self.isselected then
			love.graphics.setColor(255,0,0,255)
			--print "This one selected"
		else
			love.graphics.setColor(255, 255, 255, 255)
			--print "this one not"
		end
		
		local width = love.graphics.getWidth()
		local height = love.graphics.getHeight()
		
		love.graphics.translate(self:XCenterDistanceFromOrigin(), self:YCenterDistanceFromOrigin())
		love.graphics.rotate(self.angle)
		love.graphics.translate(-1*self:XCenterDistanceFromOrigin(), -1*self:YCenterDistanceFromOrigin())
		
		love.graphics.rectangle("fill", self:GetPixelX(), self:GetPixelY(), utilHandler:TD(self.front), utilHandler:TD(self.side) );
		love.graphics.setPointSize(5)
		
		
		love.graphics.setColor(20, 20, 20, 255)
		
		love.graphics.point(self:XCenterDistanceFromOrigin(), self:GetPixelY()+self:GetSidePixel())--
		
		love.graphics.translate(self:XCenterDistanceFromOrigin(), self:YCenterDistanceFromOrigin())
		love.graphics.rotate(-1*self.angle)
		love.graphics.translate(-1*self:XCenterDistanceFromOrigin(), -1*self:YCenterDistanceFromOrigin())
		
		love.graphics.setColor(255,0,0,255)
		
		if self.waypointlist ~= nil and self.isselected then
            for i,v in ipairs(self.waypointlist) do
                v:draw()
            
            end
        end		
		
	end
	
	function self:selected()
		self.isselected = true
	end
	
	
	function self:XCenterDistanceFromOrigin()
		
		return self:GetPixelX()+self:GetFrontPixel()/2
	end
	
	function self:GetAngleToPointer()
		mouseX, mouseY = love.mouse.getPosition( )
		return self:GetAngleToCoordinatesPixel(mouseX, mouseY)
        --return math.atan2(mouseX - self:GetPixelX(), mouseY- self:GetPixelY())se
	end

    function self:GetAngleToCoordinatesPixel(x, y)
        
		return math.atan2(x - self:GetPixelX(), y- self:GetPixelY())
    
    end
	function self:GetAngleToCoordinates(x, y)
        
		return math.atan2(x - self.x, y- self.y)
    
    end
	
	function self:YCenterDistanceFromOrigin()
		return self:GetPixelY()+self:GetSidePixel()/2
	end
	
	--TODO: change this to handle rotation
	function self:pixelInterSection(x, y)
	    local xMin, xMax, yMin, yMax
	    xMin = self:GetPixelX()
	    xMax = xMin+utilHandler:TD(self.front)
	    yMin = self:GetPixelY()
	    yMax = yMin+ utilHandler:TD(self.side)

        if x >= xMin and x <= xMax and y>=yMin and y<=yMax then return true else return false end
	      
	end
	
	function self:move(secDt)
		print(self.mtrsMovementVector.x)
	    self.x = self.x+(self.mtrsMovementVector.x * secDt)
	    self.y = self.y+(self.mtrsMovementVector.y * secDt)
	    
	    
	    local NextWaypoint = self.waypointlist[1]
		
	    if self.currentAction == enums.NextAction.standStill then
	        --Accelerate in a direction
			if(NextWaypoint ~= nil) then
			    
				if collisionCheck:CheckTwoObjects(self, NextWaypoint) then
				    self:removeWayPoint()
				
				else
				    local radAngleToWayPoint = utilHandler.GetAngleToCoordinates(NextWayPoint.x, NextWayPoint.y) --why negative?
				    --first figure out if the angle is -1 or positive, then Multiply by -1
				    local normradAngleToWapoint = radAngleToWayPoint % (math.pi *2)
				    local normAngle = self.angle % (math.pi *2)
				    
				    if normAngle > normradAngleToWaypoint then
				        
                        angle = normAngle + radsMaxRotate * secDt
				    elseif  normAngle < normradAngleToWaypoint then
				        
                        angle = normAngle - radsMaxRotate * secDt
				    else
				    
				    
				    end
				    
				    -- if angle = radAngleToWaypoint ( do nothing!)
				    -- if |radAngleToWaypoint - angle| > radsMaxRotate * secDt rotate towards radAngleToWaypoint radsMaxRotate * secDt
				    -- else set angle = radAngleToWaypoint
				    
				end
				
			end
	    elseif self.currentAction == enums.NextAction.movingStraight or self.currentAction == enums.NextAction.turnAndMove then
	        --Check angle/accell and choose to move to either a hard move or a slower turn
			self.x = self.x
	    elseif self.currentAction == enums.NextAction.hardTurn then
            --Hard Move until stop, then set direction towards way point
			self.x = self.x
        end
	end
	
	--Waypoint related
	function self:removeWayPoint()
	    
        table.remove(self.waypointlist, 1)
	end
	
	--BOUNDING BOX RELATED FUNCTIONS
	function self:mtrULx()
		return self.x
	end
	
	function self:mtrURx()
		return (self.x + self.front)
	end
	function self:mtrBLy()
		return (self.y+self.side)
	end
	function self:mtrULy()
		return self.y
	end
	
	return self
end


return player