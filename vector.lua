local Vector = {}

function Vector.new(xUser, yUser, zUser) --IN METERS
	local self ={}
	local utilFuncs = require("Utils")
	local UtilFuncs = utilFuncs.new()
	print ("Xuser: ")
	print (xUser)
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

	function self:draw()
		love.graphics.setColor(255,255,255,255)
		love.graphics.setLine(2, "smooth")
		local absolX, absolY = self:AbsouteStartPoints()
		love.graphics.line(
					absolX,
					absolY, 
					absolX+ UtilFuncs:TD(self.x), 
					absolY+UtilFuncs:TD(self.y))
		love.graphics.setColor(155,155,0,255)
		love.graphics.setPointSize(5)
		love.graphics.point(absolX+ UtilFuncs:TD(self.x),absolY+UtilFuncs:TD(self.y))
	
	end
	
	function self:AbsouteStartPoints()
		return UtilFuncs:TranslateXMeterToPixel(self.origX),
					UtilFuncs:TranslateYMeterToPixel(self.origY)
	end
	
	function self:AbsoluteEndPoints()
		
		
		return UtilFuncs:TranslateXMeterToPixel(self.origX)+ UtilFuncs:TD(self.x), UtilFuncs:TranslateYMeterToPixel(self.origY)+UtilFuncs:TD(self.y)
	end
	
	function self:SetSelfFromAbsol(absolX,absolY)
		
		local absolStartX, absolStartY = self:AbsouteStartPoints()
		self.x = UtilFuncs:TDPixel(absolX - absolStartX)
		self.y = UtilFuncs:TDPixel(absolY - absolStartY)
	end
	
	
	return self
end
return Vector