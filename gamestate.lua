local gamestate = {}
local utils = require("utils")
function gamestate.new()
	self.playerTeam = 0
	self.selectedPlayer  = nil
	self.throwVector = nil
	self.drawThrowVector = false
	self.posessingPlayer = nil
	return self

end

return gamestate