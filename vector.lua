local VectorLib = {}

function VectorLib:Add(Vec1, Vec2)
	local returnable = {x =( Vec1.x+Vec2.x ), y= (Vec1.y+ Vec2.y) }
	
end

function VectorLib:Magnitude(Vec1)
	return (math.sqrt(Vec1.x^2 + Vec1.y^2))
end
	
return VectorLib