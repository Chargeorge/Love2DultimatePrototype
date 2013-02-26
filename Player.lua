local player = {}
local utils = require("utils")
function player.new()
	local self = {}
	local utilHandler = utils.new()
	self.x  = 40 -- need to create a coordinate system
	self.y = 40 
	self.side = .8;
	self.front = 1.2;
	self.angle = 0;
	self.z = 0 -- Z is the bottom of the foot
	self.height = 0 -- height to head
	self.armLen = 0-- length of arm
	self.playerId = math.random(1, 1000000) --TODO: Need to take a look at this, and ensure no collisions.
	
	self.isselected = false
	--print (utilHandler:TranslateXMeterToPixel(self.x))
	
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
		
	end
	
	function self:selected()
		self.isselected = true
	end
	
	
	function self:XCenterDistanceFromOrigin()
		
		return self:GetPixelX()+self:GetFrontPixel()/2
	end
	
	function self:GetAngleToPointer()
		mouseX, mouseY = love.mouse.getPosition( )
		return math.atan2(mouseX - self:GetPixelX(), mouseY- self:GetPixelY())
	end

	
	function self:YCenterDistanceFromOrigin()
		return self:GetPixelY()+self:GetSidePixel()/2
	end
	
	return self
end

return player