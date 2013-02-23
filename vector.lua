local Vector = {}

function Vector.new(xUser, yUser, zUser) --IN METERS
	local self ={}
	local utilFuncs = require("Utils")
	local UtilFuncs = utilFuncs.new()
	self.x =xUser
	self.y = yUser
	self.z = zUser
	self.origX =  0
	self.origY = 0
	
	function self:Add( Vec2)
		local returnable =  Vector.new(( self.x+Vec2.x ), (self.y+ Vec2.y))
		return returnablee
	end

	function self:Magnitude()
		return (math.sqrt(self.x^2 + self.y^2))
	end

	function self:draw(v1, origX, origY)
		love.graphics.setColor(255,255,255,255)
		love.graphics.setLine(3, "smooth")
		love.graphics.line(
					utilHandler:TranslateXMeterToPixel(orgiX),
					utilHandler:TranslateYMeterToPixel(origY), 
					utilHandler:TranslateXMeterToPixel(orgiX)+ utilHandler:TD(v1.x), 
					utilHandler:TranslateYMeterToPixel(origY)+utilHandler:TD(v1.y))
		love.graphics.setColor(0,255,255,255)
		love.graphics.setPointSize(4)
		love.graphics.point(utilHandler:TranslateXMeterToPixel(orgiX)+ utilHandler:TD(v1.x), utilHandler:TranslateYMeterToPixel(origY)+utilHandler:TD(v1.y))
	
	end
	
	function self:AbsouteStartPoints()
		return utilHandler:TranslateXMeterToPixel(orgiX),
					utilHandler:TranslateYMeterToPixel(origY)
	end
	
	function self:AbsoluteEndPoints()
		
		
		return utilHandler:TranslateXMeterToPixel(orgiX)+ utilHandler:TD(v1.x), utilHandler:TranslateYMeterToPixel(origY)+utilHandler:TD(v1.y)
	end
	
	return self
end
return Vector