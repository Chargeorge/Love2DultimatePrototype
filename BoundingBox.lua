local BoundingBox = {}

local utils = require("utils")

local enums = require("enums")
function BoundingBox.new(x, y, front, side)
	local self = {}
	self.debugMode = true
	self.CollisionCheckType = enums.CollisionCheckType.box
	self.x = x
	self.y = y
	self.front = front
	self.side = side
	
	local UtilFuncs = utils.new()
	function self:updateXY(x,y)
		self.x = x
		self.y  = y
	end
	
	function self:pointmtrUL()
		return {x=self.x, y=self.y}
	end
	function self:left()
		return self.x
	end
	function self:right()
		return self.x+self.front
	end
	function self:top()
		return self.y
	end
	function self:bottom()
		return y+self.side
	end
	
	function self:pointmtrUR()
		
		return {x=self.x+self.front, y=self.y}
	end	
	function self:pointmtrBL()
		
		return {x=self.x, y=self.y+self.side}
	end
	function self:pointmtrBR()
		return {x=self.x+self.front, y=self.y+self.side}
	end
	
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
	
	function self:draw()
		if self.debugMode then
			love.graphics.setColor(255,192,203,255)	
			love.graphics.setLine(2, "smooth")
			love.graphics.rectangle("line", UtilFuncs:TranslateXMeterToPixel(self.x), UtilFuncs:TranslateYMeterToPixel(self.y), (UtilFuncs:TD(self.front)), UtilFuncs:TD(self.side))
		end
	end
	
	function self:pixelInterSection(x, y)
	    
		print "testing intersectin"
		local xMin, xMax, yMin, yMax
	    xMin = 	UtilFuncs:TranslateXMeterToPixel(self:left())
	    xMax = xMin+UtilFuncs:TD(self.front)
	    yMin = UtilFuncs:TranslateYMeterToPixel(self:top())
						 
	    yMax = yMin+ UtilFuncs:TD(self.side)
		
		--print ("x y meter: " ..self.x .. " " .. self.y) --DEBUG
		--print ("xMinMax: " ..xMin .. " " .. xMax)  --DEBUG
		--print ("YMinMax: " ..yMin .. " " .. yMax)  --DEBUG
		--print ("y meter" .. self:top())
        --print ("x, y" .. x .. " " .. y)
		if x >= xMin and x <= xMax and y>=yMin and y<=yMax then return true else return false end
	      
	end
	return self
end

return BoundingBox