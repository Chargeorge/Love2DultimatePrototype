local player = {}
local utils = require("utils")
local enums = require("enums")
local vector = require("vector")
local collisionChecker = require("collisionChecker")
local boundingBox = require("boundingbox")
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
	self.myBoundingBox = boundingBox.new(self.x, self.y, self.front, self.side)
	--Stats
	self.mtrsMaxSpeed = 4
	self.mtrssMaxAccel = 2
	self.mtrssMaxDeccel = 8
	self.radsMaxRotate = math.pi*2
	--print (utilHandler:TranslateXMeterToPixel(self.x))
	
	--Internals
	
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
		print(self.angle)
		
		love.graphics.rectangle("fill", self:GetPixelX(), self:GetPixelY(), utilHandler:TD(self.front), utilHandler:TD(self.side) );
		love.graphics.setPointSize(5)
		--
		
		love.graphics.setColor(20, 20, 20, 255)
		
		love.graphics.point(self:XCenterDistanceFromOrigin(), self:GetPixelY())--
		
		love.graphics.translate(self:XCenterDistanceFromOrigin(), self:YCenterDistanceFromOrigin())
		love.graphics.rotate(-1*self.angle)
		love.graphics.translate(-1*self:XCenterDistanceFromOrigin(), -1*self:YCenterDistanceFromOrigin())
		
		love.graphics.setColor(255,0,0,255)
		self.mtrsMovementVector.origX = self.x
		self.mtrsMovementVector.origY = self.y
		
		self.mtrsMovementVector:draw()
		self.myBoundingBox:draw()
		if self.waypointlist ~= nil and self.isselected then
            for i,v in ipairs(self.waypointlist) do
                v:draw()
            
            end
        end		
		
	end
	
	function self:selected()
		self.isselected = true
	end
	
	function self:GetCenterCoordinates()
	    return self.x+self.front/2, self.y+self.side/2
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
        
		return math.atan2(x - self:GetPixelX(), self:GetPixelY()- y ) --- Coordinate system is transposed over Y axis
    
    end
	function self:GetAngleToCoordinates(x, y)
        local centerX, centerY  = self:GetCenterCoordinates() --- Coordinate system is transposed over Y axis
		return math.atan2(x - centerX,  centerY - y)
    
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
		
	    self.x = self.x+(self.mtrsMovementVector.x * secDt)
	    self.y = self.y+(self.mtrsMovementVector.y * secDt)
	    self.myBoundingBox:updateXY(self.x,self.y)
	    
	    local NextWaypoint = self.waypointlist[1]
		
	    if self.currentAction == enums.NextAction.standStill then
	        --Accelerate in a direction
			if(NextWaypoint ~= nil) then
			    
				if collisionCheck:CheckTwoObjects(self, NextWaypoint) then
				    self:removeWayPoint()
				
				else
				    local radAngleToWayPoint = self:GetAngleToCoordinates(NextWaypoint.x, NextWaypoint.y) 
				    --first figure out if the angle is -1 or positive, then Multiply by -1
				    
				    local normradAngleToWaypoint = utilHandler:round((radAngleToWayPoint+ math.pi*2) % (math.pi *2),5) --handle when negative or > 2pi
				    
                    local normAngle = utilHandler:round((self.angle + math.pi*2) % (math.pi *2),5)
				    
				    if normAngle > normradAngleToWaypoint then
				        local newAngle = (normAngle - self.radsMaxRotate * secDt) % (math.pi *2)
				        if newAngle > normradAngleToWaypoint then
                            self.angle = newAngle
                        else
                            self.angle = normradAngleToWaypoint
                        end
                        --TODO: add back some acceleration
				    elseif  normAngle < normradAngleToWaypoint then
				        local newAngle =(normAngle + self.radsMaxRotate * secDt) % (math.pi *2)
                        if newAngle < normradAngleToWaypoint then
                            self.angle = newAngle
                        else
                            self.angle = normradAngleToWaypoint
                        end
                        
                        --TODO: add back some acceleration
				    else
				        -- accellmag = accell*secDT, unless Acceleration * secDt > maxSpeed, in which case mag of new vector = maxSpeed
				        local mtrsAccelerationThisFrame = self.mtrssMaxAccel * secDt 
                        self.mtrsMovementVector:SetSelfFromMagAngle(mtrsAccelerationThisFrame, self.angle)
				        self.currentAction = enums.NextAction.movingStraight				        
				    
				    end
				    
				    -- if angle = radAngleToWaypoint ( do nothing!)
				    -- if |radAngleToWaypoint - angle| > radsMaxRotate * secDt rotate towards radAngleToWaypoint radsMaxRotate * secDt
				    -- else set angle = radAngleToWaypoint
				    
				end
				
			end
	    elseif self.currentAction == enums.NextAction.movingStraight or self.currentAction == enums.NextAction.turnAndMove then
	        --Check angle/accell and choose to move to either a hard move or a slower turn
			if(NextWaypoint ~= nil) then
			    
				if collisionCheck:CheckTwoObjects(self.myBoundingBox, NextWaypoint) then
				    self:removeWayPoint()
				    self.mtrsMovementVector = vector.new(0,0,0) --TODO decelerate
				    self.currentAction = enums.NextAction.standStill
				else
				    -- continue accelerating
				    
                    local mtrsAccelerationThisFrame = self.mtrssMaxAccel * secDt 
                    local mtrsAccelerationVector = vector.new(0,0,0)
                    mtrsAccelerationVector:SetSelfFromMagAngle(mtrsAccelerationThisFrame, self.angle)
                    local mtrsNewMovementVector = self.mtrsMovementVector:Add( mtrsAccelerationVector )
                    if (mtrsNewMovementVector:Magnitude() < self.mtrsMaxSpeed) then
                    
                        self.mtrsMovementVector = self.mtrsMovementVector:Add(mtrsAccelerationVector)
                    else
                        self.mtrsMovementVector:SetSelfFromMagAngle(self.mtrsMaxSpeed, self.angle)
                    end-- maxcheck
				end--collisionCheckElse
			end --waypoint check
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
	--REMOVED TO IT'S OWN OBJECT :)
	return self
end


return player