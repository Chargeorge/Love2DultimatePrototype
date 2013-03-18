local Enums = {}

local NextAction =  {
hardTurn = 0,
turnAndMove = 1,
jump = 2,
standStill = 3,
movingStraight = 4
}

local NextDecision =  {
moveToWaypoint = 0,
returnToPlayPosition = 1,
rest = 2,
letPhysicsHappen = 3
}

local CollisionCheckType = {
    box = 0,
    point = 1,
    straightBox = 2
}

Enums.NextAction = NextAction
Enums.NextDecision = NextDecision
Enums.CollisionCheckType = CollisionCheckType

return Enums