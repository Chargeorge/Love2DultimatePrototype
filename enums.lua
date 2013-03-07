local Enums = {}

local NextAction =  {
turn = 0,
turnAndMove = 1,
jump = 2
}

local NextDecision =  {
moveToWaypoint = 0,
returnToPlayPosition = 1,
rest = 2,
letPhysicsHappen = 3
}

return Enums