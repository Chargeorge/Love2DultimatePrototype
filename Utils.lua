local utils = {}
function utils.new()
	local self = {}
	
	self.PixelMeterConversion = 10 --Pixels / Meter
	self.StartField = {x = 0, y = 100} -- In pixels where to start rendering the field
	
	function self:TranslateMeterToPixel(x, y)
		local TranslatedX, TranslatedY
		TranslatedX = (x*self.PixelMeterConversion)+self.StartField.x
		TranslatedY = (y*self.PixelMeterConversion)+self.StartField.Y
	
		return math.floor(TranslatedX + .5), math.floor(TranslatedY + .5)
	end
	function self:TranslateXMeterToPixel(x)
		local TranslatedX

		TranslatedX = (x*self.PixelMeterConversion)+self.StartField.x
	
		return math.floor(TranslatedX + .5)
	end
	function self:TranslateYMeterToPixel(y)
		local  TranslatedY
		TranslatedY = (y*self.PixelMeterConversion)+self.StartField.y
	
		return math.floor(TranslatedY + .5)
	end

	function self:TranslateDistance(len)
		return (math.floor((len* self.PixelMeterConversion)+.5))
	end
	
	function self:TD(len)	
		return self:TranslateDistance(len)
	end
	
	function self:TranslateXPixelToMeter(x)
		local TranslatedX

		TranslatedX = (x/self.PixelMeterConversion)-self.StartField.x
	
	end
	
	
	function self:TranslateYPixelToMeter(y)
		local TranslatedY

		TranslatedY = (y/self.PixelMeterConversion)-self.StartField.y
	return self
	
	


end
return utils