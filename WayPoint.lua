local utils = require("utils")
local WayPoint = {}

function WayPoint.new(x,y)
    local self = {}
    local UtilHandler = utils.new()
    self.x = x
    self.y = y
    
    
    
    function self:draw()
        love.graphics.setColor(255, 0, 0, 255 )
        love.graphics.setPoint(4,"smooth")
        
        love.graphics.point(UtilHandler:TranslateXMeterToPixel(self.x), UtilHandler:TranslateYMeterToPixel(self.y))
    end
    
    return self
    
end

return WayPoint