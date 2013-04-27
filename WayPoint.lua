local utils = require("utils")
local boundingBox = require("boundingBOx")
local WayPoint = {}

function WayPoint.new(x,y)
    local self = {}
    local UtilHandler = utils.new()
    self.x = x
    self.y = y
    self.decelRadius = 3  --TODO: Calculate per player
    self.myBoundingBox = boundingBox.new(self.x-self.decelRadius/2, self.y-self.decelRadius/2, self.decelRadius, self.decelRadius)
    
    
    function self:draw()
        love.graphics.setColor(255, 0, 0, 255 )
        love.graphics.setPoint(4,"smooth")
        
        love.graphics.point(UtilHandler:TranslateXMeterToPixel(self.x), UtilHandler:TranslateYMeterToPixel(self.y))
        self.myBoundingBox:draw()
        
    end
    
    return self
    
end

return WayPoint