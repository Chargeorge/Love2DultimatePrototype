local disk = {}
local utilFuncs = require("Utils")
local Vector = require("vector")
local boundingBox = require("boundingbox")
local enums = require("enums")


function disk.new(gameState)
	--[[Loading section ]]
	local UtilFuncs = utilFuncs.new()
	
	
	local self = {}
	self.gameState = gameState
	self.currentDiscState = enums.discState.ground
	
	self.x = 30 -- left point in meters
	self.y = 30 -- Top point in meters
	self.z = 1 
	self.groundZ = 0 --Can be modified to create special discs that tell you when they reach a certain height
	self.rotation = {x=0, y= 0}
	self.velocityVector = Vector.new( 0,  0,  0) -- Absolute m/s
	self.radius = .5
	self.posessingPlayer = {}
	self.estimatedPosition = nil --= disk.new() Create a disk, launch it, run through a full move
	self.color = {r=255,g=255,b=255,alpha=255}
	local zConstant = .5
	local gravityDefault = .07
	self.myBoundingBox = boundingBox.new(self.x-self.radius,self.y-self.radius, self.radius*2, self.radius*2)

	--[[Throwing methods]]
	function self:throw(velVector)
		self.currentDiscState = enums.discState.inflight
		self.velocityVector = velVector
		self.z = 1.5
		self.posessingPlayer = {}
		self:EstimateFinalPosition(.017,0) --TODO: remove hacked in value
	end
	
	
	function self:updateposition(dt)
		if self.z > 0 and self.currentDiscState == enums.discState.inflight then
		
			
			self.x = self.x+self.velocityVector.x* (dt)
			self.y = self.y+self.velocityVector.y* (dt)
			
			--print ("Z valPreop: " .. self.z)
			self.z = self.z + self.velocityVector:Magnitude()*zConstant* (dt) - gravityDefault
			--print ("Vector Magnitude" .. Vector:Magnitude(self.velocityVector))
			
			--print ("Z val: " .. self.z)
			
			if self.z <= self.groundZ then 
				self.currentDiscState = enums.discState.ground
				self.z = self.groundZ
				self.velocityVector.x = 0
				self.velocityVector.y = 0
			end
			self:updateFlightVector(dt)
		end
		
		if self.currentDiscState == enums.discState.playerhand then
			self.x = self.posessingPlayer.x+math.cos(self.posessingPlayer.angle)*self.posessingPlayer.front-- + self.posessingPlayer.front
			self.y = self.posessingPlayer.y+math.sin(self.posessingPlayer.angle)*self.posessingPlayer.side--+self.posessingPlayer.side
			--print (self.x) 
			--print (self.y)
			self.z = 1
		end
		self.myBoundingBox:updateXY(self.x-self.radius, self.y-self.radius)
	end
	
	function self:EstimateFinalPosition(dt, newGroundZ) 
	    self.estimatedPosition  = self:spawnEstimatedPosition(dt, newGroundZ) 
	    
    end
	
	function self:spawnEstimatedPosition(dt, newGroundZ)
	    local estimatedPosition
        estimatedPosition = disk.new()
	    estimatedPosition.x = self.x
	    estimatedPosition.y = self.y
	    estimatedPosition.z = self.z
	    estimatedPosition.groundZ = newGroundZ
	    estimatedPosition.color = {r=0,g=255,b=255,alpha=255}
	    estimatedPosition.velocityVector = self.velocityVector:clone()
	    estimatedPosition.currentDiscState = enums.discState.inflight
        while estimatedPosition.z > newGroundZ do
	        estimatedPosition:updateposition(dt)
	    end
	    return estimatedPosition
	end
	
	function self:updateFlightVector(dt)
		if self.z > 0 and self.currentDiscState == enums.discState.inflight then
			
			self.velocityVector.x = self.velocityVector.x / (1+dt)
			self.velocityVector.y =self.velocityVector.y / (1+dt)
			
			
		end
	end
	
	function self:caught(player)
		self.currentDiscState = enums.discState.playerhand
		self.posessingPlayer = player

	end
	
	function self:draw()
		love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.alpha)	
		love.graphics.circle("fill", UtilFuncs:TranslateXMeterToPixel(self.x), UtilFuncs:TranslateYMeterToPixel(self.y), (UtilFuncs:TD(self.radius) * (1+self.z/10) ))
		self.myBoundingBox:draw()
		if self.estimatedPosition ~= nil and self.currentDiscState == enums.discState.inflight then
		    self.estimatedPosition:draw()
		end
	end
	
	function self:pixelIntersection(x,y)
		return self.myBoundingBox:pixelInterSection(x,y)
	end
	
	return self

end

return disk