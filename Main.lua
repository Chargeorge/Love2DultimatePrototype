local player = require("Player")
local disk = require("disk")
local field = require("field")
local Utils = require("utils")
local vector = require("vector")
local gamestate = require("gamestate")
local waypoint = require("WayPoint")
debugFlg = false



function love.load()
    
	gameState = gamestate.new()
	gameState.throwVector = nil
	gameState.drawThrowVector = false
	gamedisk = disk.new(gameState)
	gamedisk.x =30
	gamedisk.y = 30
	gamedisk.z = 0
	gameState.gameDisc = gamedisk
	mainplayer = player.new(gameState)
	player2 = player.new(gameState)
	player2.x = 20
	player2.y = 20
	mainplayer.x = 15
	mainplayer.y = 38
	
	gameState.selectedPlayer = player2
	--table.insert(mainplayer.waypointlist, wayPointer)
	
	Field = field.new()
    
	player2:selected()
	player2.angle = math.pi/2
	playerobjs = {mainplayer, player2}
	--testVector = vector.new(10,10)
	--testVector.origX = player2.x;
	--testVector.origY = player2.y;

end

function love.draw()
	Field:draw()
	mainplayer:draw()

	player2:draw()
	gamedisk:draw()
	if gameState.drawThrowVector and gameState.throwVector ~= nil then
		
		gameState.throwVector:draw();
	end
end

function love.update(dt)
	--print(mainplayer.angle)
	--mainplayer.angle = 0
    
    
    
	if gameState.drawThrowVector and gameState.throwVector ~= nil then
		gameState.throwVector:SetSelfFromAbsol(love.mouse.getX(),love.mouse.getY())
	end
	gamedisk:updateposition(dt)
	mainplayer:move(dt)
	player2:move(dt)
end

function GetSelectedPlayer()
	for i,v in ipairs(playerObjs) do if(v.selected) then return v end end
	return nil
end

function love.mousepressed(x, y, button)
	if button == "r" then
	
       if gamedisk.posessingPlayer.playerId == gameState.selectedPlayer.playerId   then

            gameState.drawThrowVector = true
            gameState.throwVector  = vector.new(0,0)
            gameState.throwVector.origX = player2.x;
            gameState.throwVector.origY = player2.y;
            gameState.throwVector:SetSelfFromAbsol(x,y)
        elseif gamedisk.posessingPlayer == nil and gamedisk.pixelInterSection(x,y) and gameState.selectedPlayer ~= nil then
			table.insert(gameState.selectedPlayer.waypointlist, gamedisk)
		end
		
    else
        toSelect = nil
        for key, value in ipairs(playerobjs) do
            if value:pixelInterSection(x,y) then
                toSelect = value
                
            end    
        end
        
        if toSelect ~= nil then
            if gameState.selectedPlayer ~= nil then
                 gameState.selectedPlayer.isselected = false 
            end 
            gameState.selectedPlayer = toSelect
            toSelect.isselected = true
        end
        
    end
    
end

function love.mousereleased(x,y, button)
    if button == "r"  then
        if  gamedisk.posessingPlayer.playerId == gameState.selectedPlayer.playerId   then
            gameState.drawThrowVector = false
            gamedisk:throw(gameState.throwVector)
			
			gameState.posessingPlayer = nil
        else
        --TODO make this a method in the player

            table.insert(gameState.selectedPlayer.waypointlist, waypoint.new(gameState.Utils:TranslateXPixelToMeter(x), gameState.Utils:TranslateYPixelToMeter(y)))
        end
    end
end



