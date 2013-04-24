local Enums = {}

Enums.NextAction =  {
hardTurn = 0,
turnAndMove = 1,
jump = 2,
standStill = 3,
movingStraight = 4,
chasingDisc = 5, 
chasingPlayer = 6,
holdingDiscMoving = 7,
holdingDsicStopped = 8
}

Enums.NextDecision =  {
moveToWaypoint = 0,
returnToPlayPosition = 1,
rest = 2,
letPhysicsHappen = 3
}

Enums.CollisionCheckType = {
    box = 0,
    point = 1,
    straightBox = 2
}
Enums.MovmentReturnType = {
    maxSpeed = 1,
    stop = 2, 
    accelerating = 3
    
}

return Enums