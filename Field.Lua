local Field = {}

function Field.new()
	self = {}
	local utilFuncs = require("Utils")
	local UtilFuncs = utilFuncs.new()
	self.FieldLength = 100
	self.FieldWidth = 38
	self.LeftEndszone = 20
	self.RightEndzone = 20
	
	self.TopPad = 3
	self.RightPad = 3
	self.LeftPad = 3
	self. BottomPad = 3
	
	function self:draw()
		
		love.graphics.setColor (0,255,0,255)
		love.graphics.rectangle("fill", UtilFuncs.StartField.x, UtilFuncs.StartField.y, UtilFuncs:TranslateDistance(self.FieldLength+self.RightPad+self.LeftPad), UtilFuncs:TranslateDistance(self.FieldWidth+self.BottomPad+self.TopPad) )
	
		love.graphics.setColor(255,255,255,255)
		love.graphics.setLine(2, "smooth")
		love.graphics.rectangle("line", UtilFuncs.StartField.x+UtilFuncs:TD(self.LeftPad), UtilFuncs.StartField.y+UtilFuncs:TD(self.TopPad), UtilFuncs:TD(self.FieldLength), UtilFuncs:TD(self.FieldWidth))
		
	
	end
	
	return self
end
return Field