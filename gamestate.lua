local gamestate = {}
local utils = require("utils")
local spriteDB = require("SpriteDB")
function gamestate.new()
	--Ulti Rules globals
	self = {}
	self.posessingTeam = 0
	self.posessingPlayer = nil
	self.gameDisc = nil
	
	--Interaction Rules globals
	self.selectedPlayer  = nil
	self.throwVector = nil
	self.drawThrowVector = false
	self.sprites = spriteDB.new()
	
	self.Utils = utils.new()
    
	--UltiRules
	function self:pickupDisc(player)
		--TODO add side checking
		--Pickup disc
		self.posessingPlayer = player
		self.gameDisc.caught(player)
		
	end
	
	function self:catchDisc(player)
	
	end
	
	function self:interceptDisc(player)
	
	end
	
	return self

end

return gamestate