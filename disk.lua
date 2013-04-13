local disk = {}
local utilFuncs = require("Utils")
local Vector = require("vector")
local boundingBox = require("boundingbox")
function CreateDiskState()
	return 	{ground = 1,
	playerhand = 2,
	inflight = 3}
end

function disk.new()
	--[[Loading section ]]
	local UtilFuncs = utilFuncs.new()
	
	
	local self = {}
	
	self.staticDiskState = CreateDiskState()
	self.currentDiskState = self.staticDiskState.inflight
	
	self.x = 30 -- left point in meters
	self.y = 30 -- Top point in meters
	self.z = 1 
	self.rotation = {x=0, y= 0}
	self.velocityVector = Vector.new( 10,  10,  0) -- Absolute m/s
	self.radius = .5
	self.posessingPlayer = {}
	self.estimatedPosition = nil --= disk.new() Create a disk, launch it, run through a full move
	self.color = {r=255,g=255,b=255,alpha=255}
	local zConstant = .5
	local gravityDefault = .07
	self.myBoundingBox = boundingBox.new(self.x,self.y, self.radius*2, self.radius*2)

	--[[Throwing methods]]
	function self:throw(velVector)
		self.currentDiskState = self.staticDiskState.inflight
		self.velocityVector = velVector
		self.z = 1.5
		self.posessingPlayer = {}
		self:EstimateFinalPosition(.017) --TODO: remove hacked in value
	end
	
	
	function self:updateposition(dt)
		if self.z > 0 and self.currentDiskState == self.staticDiskState.inflight then
		
			
			self.x = self.x+self.velocityVector.x* (dt)
			self.y = self.y+self.velocityVector.y* (dt)
			
			--print ("Z valPreop: " .. self.z)
			self.z = self.z + self.velocityVector:Magnitude()*zConstant* (dt) - gravityDefault
			--print ("Vector Magnitude" .. Vector:Magnitude(self.velocityVector))
			
			--print ("Z val: " .. self.z)
			
			if self.z <= 0 then 
				self.currentDiskState = self.staticDiskState.ground
				self.z = 0
				self.velocityVector.x = 0
				self.velocityVector.y = 0
			end
			self:updateFlightVector(dt)
		end
		
		if self.currentDiskState == self.staticDiskState.playerhand then
			self.x = self.posessingPlayer.x+math.cos(self.posessingPlayer.angle)*self.posessingPlayer.front-- + self.posessingPlayer.front
			self.y = self.posessingPlayer.y+math.sin(self.posessingPlayer.angle)*self.posessingPlayer.side--+self.posessingPlayer.side
			--print (self.x) 
			--print (self.y)
			self.z = 1
		end
		self.myBoundingBox:updateXY(self.x, self.y)
	end
	
	function self:EstimateFinalPosition(dt) 
	    self.estimatedPosition = disk.new()
	    self.estimatedPosition.x = self.x
	    self.estimatedPosition.y = self.y
	    self.estimatedPosition.z = self.z
	    self.estimatedPosition.color = {r=0,g=255,b=255,alpha=255}
	    self.estimatedPosition.velocityVector = self.velocityVector:clone()
	    while self.estimatedPosition.z > 0 do
	        self.estimatedPosition:updateposition(dt)
	    end
	    
    end
	
	function self:updateFlightVector(dt)
		if self.z > 0 and self.currentDiskState == self.staticDiskState.inflight then
			
			self.velocityVector.x = self.velocityVector.x / (1+dt)
			self.velocityVector.y =self.velocityVector.y / (1+dt)
			
			
		end
	end
	
	function self:caught(player)
		self.currentDiskState = self.staticDiskState.playerhand
		self.posessingPlayer = player
	end
	
	function self:draw()
		love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.alpha)	
		love.graphics.circle("fill", UtilFuncs:TranslateXMeterToPixel(self.x), UtilFuncs:TranslateYMeterToPixel(self.y), (UtilFuncs:TD(self.radius) * (1+self.z/10) ))
		self.myBoundingBox:draw()
		if self.estimatedPosition ~= nil and self.currentDiskState == self.staticDiskState.inflight then
		    self.estimatedPosition:draw()
		end
	end
	
	
	return self

end

return disk