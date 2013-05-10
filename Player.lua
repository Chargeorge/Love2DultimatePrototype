local player = {}
local utils = require("utils")
local enums = require("enums")
local vector = require("vector")
local collisionChecker = require("collisionChecker")
local boundingBox = require("boundingbox")
local waypoint = require("WayPoint")

function player.new(gameState)
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
	self.mtrssMaxDeccel = -8
	self.radsMaxRotate = math.pi*2
	self.radCutThreshold = math.pi/3 --Point at which this dude will cut vs turn
	
    self.radsRunningTurnRate = self.radsMaxRotate--Rad/Sec running turn rate
    self.coefRunningTurnRate = .5  --Amount max speed changes angle
	--print (utilHandler:TranslateXMeterToPixel(self.x))
	self.gameState = gameState
	--Internals
	self.leftOrRight = enums.rotateDirection.noMove--during a turn move am I moving left or right?
                        
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
		--print(self.angle)
		
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
	    --xMin = self:GetPixelX()
	    --xMax = xMin+utilHandler:TD(self.front)
		yMin = self:GetPixelY()
	    print ("Player Y " .. yMin .. " player Y meter " .. self.y)
		--yMax = yMin+ utilHandler:TD(self.side)

        --if x >= xMin and x <= xMax and y>=yMin and y<=yMax then return true else return false end
		
		return self.myBoundingBox:pixelInterSection(x,y)
	      
	end
	
	function self:move(secDt)
		
	    self.x = self.x+(self.mtrsMovementVector.x * secDt)
	    self.y = self.y+(self.mtrsMovementVector.y * secDt)
	    self.myBoundingBox:updateXY(self.x,self.y)
	    
	    local NextWaypoint = self.waypointlist[1]
		if collisionCheck:CheckTwoObjects(self.myBoundingBox, gameState.gameDisc.myBoundingBox) then
			
			--Check Air or ground
			--If Air
				-- Check height
				-- IF height is valid catch
			--If Ground
				-- If Team is correct pickup
				-- else, stand by
				-- NO TEAMS YET :)
			if gameState.gameDisc.z > 0 then
				--Do Nothing for now, need to do height check and catch logic
				local flimflam = 1
			else
				self.currentAction = enums.NextAction.holdingDiscMoving
				gameState.gameDisc:caught(self)
			end -- end flight check
		
		elseif(NextWaypoint ~= nil) then
			    
				if collisionCheck:CheckTwoObjects(self.myBoundingBox, NextWaypoint) then
				    self:removeWayPoint()
				    self.mtrsMovementVector = vector.new(0,0,0) --TODO decelerate
				    self.currentAction = enums.NextAction.standStill
									
				
				elseif collisionCheck:CheckTwoObjects(self.myBoundingBox, NextWaypoint.myBoundingBox) then
				    if self.waypointlist[2] == nil then
				        self.currentAction = enums.NextAction.stopping
				        self:modMoveVector(secDt, self.mtrssMaxDeccel)
						self:removeWayPoint()
                    else 
                        local normradAngleToWaypoint = self:normradAngleToWaypoint(self.waypointlist[2])
                        if (math.abs(self.angle-normradAngleToWaypoint ) > self.radCutThreshold) then
                            self:modMoveVector(secDt, self.mtrssMaxDeccel)
                            self.currentAction = enums.NextAction.cutStopping
							self:removeWayPoint()
				        else
                            self.currentAction = enums.NextAction.turnAndMove
                            self:removeWayPoint()				            
				        end
				    end
				else
			end
		end
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		--STAND STILL
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        if self.currentAction == enums.NextAction.standStill then
	        --Accelerate in a direction
			if(NextWaypoint ~= nil) then
			
				--local radAngleToWayPoint = self:GetAngleToCoordinates(NextWaypoint.x, NextWaypoint.y) 
				--first figure out if the angle is -1 or positive, then Multiply by -1
				--local normradAngleToWaypoint = utilHandler:round((radAngleToWayPoint+ math.pi*2) % (math.pi *2),5) --handle when negative or > 2pi
				local normradAngleToWaypoint = self:normradAngleToWaypoint(NextWaypoint)
				local normAngle = utilHandler:round((self.angle + math.pi*2) % (math.pi *2),5)
				local angleDif = math.abs(normAngle - normradAngleToWaypoint)
				if normAngle - normradAngleToWaypoint ~= 0 then
					if(self.leftOrRight == enums.rotateDirection.noMove) then
						--COME BACK AND ADD FUNCTION TO DO THIS
						self.leftOrRight = self:checkLeftRight(normAngle, normradAngleToWaypoint)
					end
					--(secDt, angleTo, rotateDirection)
					self:modRotateSelf(secDt, normradAngleToWaypoint, self.leftOrRight)
					if(utilHandler:round((self.angle+ math.pi*2) % (math.pi *2),5)  == normradAngleToWaypoint) then  --Operation normalizes the vector
					
						self.leftOrRight = enums.rotateDirection.noMove
					end
					--TODO make side speed factor a per player variable
					local mtrssAccel = self.mtrssMaxAccel  * ((((normradAngleToWaypoint-angleDif) % math.pi) / math.pi))
					local additionalVector = vector.new(0,0,0)
					
					additionalVector:SetSelfFromMagAngle(mtrssAccel* secDt, normradAngleToWaypoint)
					self.mtrsMovementVector = self.mtrsMovementVector:Add(additionalVector)
					--print("self.mtrsMovementVector:" .. self.mtrsMovementVector:debugString()) --DEBUGPRINT
					--Acceleration is maxAccell/ 4*((angleToDisc%pi)/pi)
					
					--TODO: add back some acceleration
				else
					-- accellmag = accell*secDT, unless Acceleration * secDt > maxSpeed, in which case mag of new vector = maxSpeed
					local mtrsAccelerationThisFrame = self.mtrssMaxAccel * secDt 
					local additionalVector = vector.new(0,0,0)
					additionalVector:SetSelfFromMagAngle(mtrsAccelerationThisFrame, self.angle)
					
					self.mtrsMovementVector= self.mtrsMovementVector:Add(additionalVector)
					self.currentAction = enums.NextAction.movingStraight				        
					self.leftOrRight = enums.rotateDirection.noMove
				end
				
				-- if angle = radAngleToWaypoint ( do nothing!)
				-- if |radAngleToWaypoint - angle| > radsMaxRotate * secDt rotate towards radAngleToWaypoint radsMaxRotate * secDt
				-- else set angle = radAngleToWaypoint
				
			end
			
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		-- MOVEING TURNANDMOVE MOVINGSTRAIGHT
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	    elseif self.currentAction == enums.NextAction.movingStraight or self.currentAction == enums.NextAction.turnAndMove  then
	        --Check angle/accell and choose to move to either a hard move or a slower turn
				    -- continue accelerating
			if self.currentAction == enums.NextAction.movingStraight then
				self:modMoveVector(secDt, self.mtrssMaxAccel)
			else
				self:modMoveVector(secDt, self.mtrssMaxAccel)
				local normradAngleToWaypoint = self:normradAngleToWaypoint(NextWaypoint)
				local normAngle = utilHandler:round((self.angle + math.pi*2) % (math.pi *2),5)
				local angleDif = math.abs(normAngle - normradAngleToWaypoint)
				local frameLeftRight = self:checkLeftRight(normAngle, normradAngleToWaypoint)
				self:modRotateSelfMovementVector(secDt,normradAngleToWaypoint,frameLeftRight)
			end
			
                        
	    --XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		-- DISC AS WAYPOINT
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	        -- Need to do collision checks in this frame
		elseif self.currentAction == enums.NextAction.chasingDisc then 
		    -- Case #1, disc is in the air, set a waypoint at it's estimated position
            -- Case #2 Disc is on the ground, run to the disc 

             if(gameState.gameDisc.currentDiscState == enums.discState.ground) then 
                local testWP = waypoint.new(gameState.gameDisc.x, gameState.gameDisc.y)
                table.insert(self.waypointlist, 1, testWP)
            elseif(gameState.gameDisc.currentDiscState == enums.discState.inflight) then
				local testWP = waypoint.new(gameState.gameDisc.estimatedPosition.x, gameState.gameDisc.estimatedPosition.y)
				table.insert(self.waypointlist, 1, testWP)
            end
		 
            local normradAngleToWaypoint = self:normradAngleToWaypoint(self.waypointlist[1])
            
			if(self.mtrsMovementVector.x ==0 and self.mtrsMovementVector.y == 0) then
				self.currentAction = enums.NextAction.standStill
			else
				if (math.abs(self.angle-normradAngleToWaypoint ) > self.radCutThreshold) then
					self:modMoveVector(secDt, self.mtrssMaxDeccel)
					self.currentAction = enums.NextAction.cutStopping
				else
					self.currentAction = enums.NextAction.turnAndMove
												
				end
			end
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		-- CUTSTOPPING HARDSTOPPING
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	    elseif self.currentAction == enums.NextAction.cutStopping then
            --Hard Move until stop, then set direction towards way point
			if self.mtrsMovementVector.x == 0 and self.mtrsMovementVector.y == 0 then
                self.currentAction = enums.NextAction.standStill
                --self:removeWayPoint()
            else
                self:modMoveVector(secDt, self.mtrssMaxDeccel)
  
            end
        
        --XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		-- DISCSTOP holdingDiscMoving
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        elseif self.currentAction == enums.NextAction.holdingDiscMoving then
            if self.mtrsMovementVector.x == 0 and self.mtrsMovementVector.y == 0 then
                self.currentAction = enums.NextAction.holdingDiscStopped
            else
                self:modMoveVector(secDt, self.mtrssMaxDeccel)
            end
        elseif self.currentAction == enums.NextAction.holdingDiscStopped then
            self.angle = self:GetAngleToPointer()
        
        --XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		-- STOPPING
		--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        elseif self.currentAction == enums.NextAction.stopping then
            --TODO: add check for a new waypoint being added
            self:modMoveVector(secDt, self.mtrssMaxDeccel)
            if self.mtrsMovementVector.x == 0 and self.mtrsMovementVector.y == 0 then
                self.currentAction = enums.NextAction.standStill
                self:removeWayPoint()
            end
        end
        
	end
	
	function self:modMoveVector(secDt, accel)
	    
	    
        local mtrsAccelerationThisFrame = accel * secDt 
        local mtrsAccelerationVector = vector.new(0,0,0)
        mtrsAccelerationVector:SetSelfFromMagAngle(mtrsAccelerationThisFrame, self.angle)
        local mtrsNewMovementVector = self.mtrsMovementVector:Add( mtrsAccelerationVector )
		
        if accel ~= nil and  accel <  0 then 
		
			--print("mtrsAccelerationVector: " .. mtrsAccelerationVector:debugString()) --debugPrint
			--print("mtrsNewMovementVector: " .. mtrsNewMovementVector:debugString()) --debugPrint
			--print("mtrsMovementVector " .. self.mtrsMovementVector:debugString()) --debugPrint
		end	
        
        if (mtrsNewMovementVector:Magnitude() >= self.mtrsMaxSpeed) then
        
            self.mtrsMovementVector:SetSelfFromMagAngle(self.mtrsMaxSpeed, self.angle)
            return enums.MovmentReturnType.maxSpeed
        elseif mtrsNewMovementVector.x * self.mtrsMovementVector.x < 0 and mtrsNewMovementVector.y * self.mtrsMovementVector.y < 0 then
           self.mtrsMovementVector.x = 0
           self.mtrsMovementVector.y = 0
           self.mtrsMovementVector.z = 0
           return enums.MovmentReturnType.stop
           
        else
            self.mtrsMovementVector = mtrsNewMovementVector
           return enums.MovmentReturnType.accelerating
        end
	end
	
	function self:modRotateSelfMovementVector(secDt, angleTo, rotateDirection) -- Rotate Direction always 1 or -1
	    angleTo = self:normalizeAngle(angleTo)
        -- print("angleTO: " .. angleTo) --DEBUG
        local currentDif = self.angle- angleTo
        -- print("currentDif" .. currentDif)--DEBUG
        local currentMaxSpeedRatio = self.mtrsMaxSpeed/self.mtrsMovementVector:Magnitude() 
	    local convertedSpeedRatio = currentMaxSpeedRatio * self.coefRunningTurnRate
	    local modifiedRate = convertedSpeedRatio * self.radsRunningTurnRate
	    local maxTurnThisFrame = convertedSpeedRatio * secDt
        local newAngle = ( self.angle + (rotateDirection* maxTurnThisFrame))
        newAngle = self:normalizeAngle(newAngle)
	    local newDif = newAngle-angleTo
        -- print("newDif" .. newDif)--DEBUG
        
        if (newDif== 0) then
            self.angle = newAngle 
        else
            local newRotation = self:checkLeftRight(newAngle, angleTo)
            if (newRotation ~= rotateDirection) then 
                self.angle = angleTo
                newAngle = angleTo
            else
                self.angle = newAngle
                
            end
        end
        local newDif = newAngle -self.angle
        self.mtrsMovementVector:rotate(newDif)
	end
	
	function self:modRotateSelf(secDt, angleTo, rotateDirection) -- Rotate Direction always 1 or -1
	    angleTo = self:normalizeAngle(angleTo)
        -- print("angleTO: " .. angleTo) --DEBUG
        local currentDif = self.angle- angleTo
        -- print("currentDif" .. currentDif)--DEBUG
	    local newAngle = ( self.angle + ((rotateDirection)* (self.radsMaxRotate * secDt))) % (math.pi *2)
	    -- print("newAngle" .. newAngle)--DEBUG
        newAngle = self:normalizeAngle(newAngle)
	    local newDif = newAngle-angleTo
        -- print("newDif" .. newDif)--DEBUG
        
        if (newDif== 0) then
            self.angle = newAngle 
        else
            local newRotation = self:checkLeftRight(newAngle, angleTo)
            if (newRotation ~= rotateDirection) then 
                self.angle = angleTo
                
            else
                self.angle = newAngle
            end
        end
	end
	
	--Waypoint related
	function self:removeWayPoint()
	    
        table.remove(self.waypointlist, 1)
	end
	
	function self:throw()
	    self.currentAction = enums.NextAction.standStill
	end
	
	function self:normalizeAngle(angleIn)
	    local returnable = angleIn
	    while returnable < 0 do
	        returnable = returnable + (math.pi*2)
	    end
	    return returnable % (math.pi*2)
	end
	
	function self:checkLeftRight(normAngle, normradAngleToWaypoint)
        local leftOrRight
        local angleDif = math.abs(normAngle - normradAngleToWaypoint)
        if(normAngle < normradAngleToWaypoint) then
            if(angleDif > math.pi ) then --Counter Clock Wise
                leftOrRight  = enums.rotateDirection.counterClockWise
                
            else
                leftOrRight  = enums.rotateDirection.clockWise
                
            end
        else
            if(angleDif < math.pi ) then --Counter Clock Wise
                leftOrRight  = enums.rotateDirection.counterClockWise
                
            else
                leftOrRight  = enums.rotateDirection.clockWise
                
            end
        end
        return leftOrRight
	end
	
	function self:normradAngleToWaypoint(waypoint)
	    local radAngleToWayPoint = self:GetAngleToCoordinates(waypoint.x, waypoint.y) 
				    --first figure out if the angle is -1 or positive, then Multiply by -1
		local normradAngleToWaypoint = utilHandler:round((radAngleToWayPoint+ math.pi*2) % (math.pi *2),5) --handle when negative or > 2pi
        return normradAngleToWaypoint 
	end
	--BOUNDING BOX RELATED FUNCTIONS
	--REMOVED TO IT'S OWN OBJECT :)
	return self
end


return player