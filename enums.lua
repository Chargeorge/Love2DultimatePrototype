local Enums = {}

Enums.NextAction =  {

turnAndMove = 1,
jump = 2,
standStill = 3, -- don't matter
movingStraight = 4, -- Position set, run at full speed
chasingDisc = 5,  -- Chasing the disc, make a guess based on where it's going
chasingPlayer = 6, --A player is the next waypoint, AI based moevement
holdingDiscMoving = 7, --Caught the disc and taking the allowed steps
holdingDiscStopped = 8,  --Disc in hand, fully stopped, don't don any further movements or some old guy will call travel
stopping  = 9, -- Flat stop
cutStopping = 10, --Cut stopping is unique as the player is expected to cut stop, and immediately go into the next move
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

Enums.discState = {ground = 1,
	playerhand = 2,
	inflight = 3}

return Enums