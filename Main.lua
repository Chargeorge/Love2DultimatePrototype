local player = require("Player")
local disk = require("disk")
local field = require("field")
local Utils = require("utils")
local vector = require("vector")
local gamestate = require("gamestate")
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
	gameState = gamestate.new()
	gameState.throwVector = nil
	gameState.drawThrowVector = false
	gameState.selectedPlayer = player2
end

function love.draw()
	Field:draw()
	mainplayer:draw()
	player2:draw()
	
	gamedisk:draw()
	if gameState.drawThrowVector and gameState.throwVector ~= nil then
		print "drawin"
		gameState.throwVector:draw();
	end
end

function love.update(dt)
	mainplayer.angle = -1*mainplayer:GetAngleToPointer()
	player2.angle = -1*player2:GetAngleToPointer()
	if gameState.drawThrowVector and gameState.throwVector ~= nil then
		gameState.throwVector:SetSelfFromAbsol(love.mouse.getX(),love.mouse.getY())
	end
	gamedisk:updateposition(dt)

end

function GetSelectedPlayer()
	for i,v in ipairs(playerObjs) do if(v.selected) then return v end end
	return nil
end

function love.mousepressed(x, y, button)
	print "In mouse pressed event"
	if gamedisk.posessingPlayer.playerId == gameState.selectedPlayer.playerId then
		print "In conditional"
		gameState.drawThrowVector = true
		gameState.throwVector  = vector.new(0,0)
		gameState.throwVector.origX = player2.x;
		gameState.throwVector.origY = player2.y;
		gameState.throwVector:SetSelfFromAbsol(x,y)
		
	end
	

end

function love.mousereleased(x,y, button)
	gameState.drawThrowVector = false
	gamedisk:throw(gameState.throwVector)
end

