local player = require("Player")
local disk = require("disk")
local field = require("field")
local Utils = require("utils")
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
end

function love.draw()
	Field:draw()
	mainplayer:draw()
	player2:draw()
	
	gamedisk:draw()
end

function love.update(dt)
	mainplayer.angle = -1*mainplayer:GetAngleToPointer()
	
	player2.angle = -1*player2:GetAngleToPointer()
	
	gamedisk:updateposition(dt)
end