local disk = {}

function CreateDiskState()
	return 	{ground = 1,
	playerhand = 2,
	inflight = 3}
end

function disk.new()
	--[[Loading section ]]
	local utilFuncs = require("Utils")
	local UtilFuncs = utilFuncs.new()
	
	local Vector = require("vector")
	
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
	
	local zConstant = .5
	local gravityDefault = .07
	
	--[[Throwing methods]]
	function self:throw(velVector)
		self.currentDiskState = self.staticDiskState.inflight
		self.velocityVector = velVector
		self.z = 1.5
		self.posessingPlayer = {}
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
		love.graphics.setColor(255,255,255,255)	
		love.graphics.circle("fill", UtilFuncs:TranslateXMeterToPixel(self.x), UtilFuncs:TranslateYMeterToPixel(self.y), (UtilFuncs:TD(self.radius) * (1+self.z/10) ))
	end
	return self

end

return disk