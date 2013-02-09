player = {};
debugFlg = false
function player.new()
	local self = {};
	self.x  = 400 -- need to create a coordinate system
	self.y = 400 
	self.side = 50;
	self.front = 100;
	self.angle = math.pi/2;
	function self:draw()
		love.graphics.setColor(255,255,255,255)
		
		local width = love.graphics.getWidth()
		local height = love.graphics.getHeight()
		
		love.graphics.translate(self:XCenterDistanceFromOrigin(), self:YCenterDistanceFromOrigin())
		love.graphics.rotate(self.angle)
		love.graphics.translate(-1*self:XCenterDistanceFromOrigin(), -1*self:YCenterDistanceFromOrigin())
		
		love.graphics.rectangle("fill", self.x, self.y, self.front, self.side);
	end
	
	function self:XCenterDistanceFromOrigin()
		return self.x+self.front/2
	end
	
	function self:YCenterDistanceFromOrigin()
		return self.y+self.side/2
	end
	
	return self
end

function love.load()
	mainplayer = player.new()
end

local angle = 0
function love.draw()
    --[[ local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    -- rotate around the center of the screen by angle radians

    -- draw a white rectangle slightly off center
    love.graphics.setColor(0xff, 0xff, 0xff)
    love.graphics.rectangle('fill', width/2-100, height/2-100, 300, 400)
    -- draw a five-pixel-wide blue point at the center
    love.graphics.setPointSize(5)
    love.graphics.setColor(0, 0, 0xff)
    love.graphics.point(width/2, height/2)
	
	love.graphics.print('Hello World!', 400, 300)
	]]--
	-- Draw the field
	
	love.graphics.setColor (0,255,0,255)
	love.graphics.rectangle("fill", 50, 0, 700, 600)

	--love.graphics.setColor(255,255,255,255)
	--love.graphics.rectangle("fill", 400, 400, 100, 100)
	
	mainplayer:draw()
	
end

function love.update(dt)
    love.timer.sleep(.01)
    angle = angle + dt * math.pi/2
    angle = angle % (2*math.pi)
end