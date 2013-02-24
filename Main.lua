local player = require("Player")
local disk = require("disk")
local field = require("field")
local Utils = require("utils")
local vector = require("vector")
debugFlg = false



function love.load()
	mainplayer = player.new()
	player2 = player.new()
	player2.x = 20
	player2.y = 20
	mainplayer.x = 0
	mainplayer.y = 38
	gamedisk = disk.new()
	Field = field.new()
	gamedisk:caught(player2)
	player2:selected()
	playerobjs = {player1, player2}
	testVector = vector.new(10,10)
	testVector.origX = player2.x;
	testVector.origY = player2.y;

	
end

function love.draw()
	Field:draw()
	mainplayer:draw()
	player2:draw()
	
	gamedisk:draw()
	testVector:draw();
end

function love.update(dt)
	mainplayer.angle = -1*mainplayer:GetAngleToPointer()
	player2.angle = -1*player2:GetAngleToPointer()
	gamedisk:updateposition(dt)

end

function GetSelectedPlayer()
	for i,v in ipairs(playerObjs) do if(v.selected) then return v end end
	return nil
end

function love.mousepressed(x, y, button)
	

end
