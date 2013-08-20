local spriteDB = {}
local utils = require("utils")
local enums = require("enums")
local vector = require("vector")
local boundingBox = require("boundingbox")

function spriteDB.new()
    local image =love.graphics.newImage( "Art/BluePlayer.png" )
    image:setFilter("nearest", "linear")
    self.blueSheet = {}
    self.blueSheet.img = image
    self.blueSheet.up = love.graphics.newQuad(0, 0, 32,32, 128, 128)
    self.blueSheet.left = love.graphics.newQuad(0, 32, 32,32, 128, 128)
    self.blueSheet.down = love.graphics.newQuad(0, 64, 32,32, 128, 128)
    self.blueSheet.right = love.graphics.newQuad(0, 96, 32,32, 128, 128)
    
    return self
end

return spriteDB