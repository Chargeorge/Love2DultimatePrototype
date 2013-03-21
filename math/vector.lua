local class = require('basic_class_system.class')
local vector = class:new()

--@param(x : number) the x coordinate of the vector
--@param(y : number) the y coordinate of the vector
function vector:init(x,y)
  -- The x coordinate of the vector
  self.x = x
  -- The y coordinate of the vector
  self.y = y
end

--@ret(number)
function vector:GetX()
  return self.x
end

--@ret(number)
function vector:GetY()
  return self.y
end
 
--Adds other vector to this vector
--@param(other : math.vector) 
--@ret(math.vector)
function vector:__add(other)
  return vector(self.x + other:GetX(), self.y + other:GetY())
end
   
--Subtracts other vector from this vector.
--@param(other : math.vector) 
--@ret(math.vector)
function vector:__sub(other)
  return vector(self.x - other:GetX(), self.y - other:GetY())
end

--@param(scalar : number) The scalar to scale by
--@ret(math.vector) This vector scaled by the scalar param
function vector:__mul(scalar)
  return vector(self.x*scalar, self.y*scalar)
end

--@ret(math.vector) The negation of this vector.
function vector:__unm()
  return vector(-self.x,-self.y)
end

-- @ret(math.vector) the perpendicular to the given vector
function vector:perp()
  return vector(-self.y,self.x)
end

--Returns the x and y coordinates of the vector
--@ret(number) The x coordinate of the vector
--@ret(number) The y coordinate of the vector
function vector:coordinates()
  return self.x, self.y
end

--@ret(number) The vector's length squared
function vector:len2()
  return self.x*self.x+self.y*self.y
end

--@ret(number) The length of the vector
function vector:len()
  return math.sqrt(self:len2())
end

-- Rotate this vector phi radians counterclockwise
--@param(phi : number) The number of radians counterclockwise to rotate the vector
function vector:rotate_inplace(phi)
	local c, s = math.cos(phi), math.sin(phi)
	self.x, self.y = c * self.x - s * self.y, s * self.x + c * self.y
	return self
end

--@param(phi : number) Number of radians to rotate counterclockwise
--@ret(math.vector) This vector rotated by phi radians counterclockwise
function vector:rotated(phi)
	local clone = vector(self.x,self.y)
  clone:rotate_inplace(phi)
  return clone
end

package.loaded[...] = vector
return vector
