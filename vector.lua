--[[
The design of this program borrows heavily from the Sample Vector implemtation in Love2d Docs, as well as the Vector API in p5.js. As a reault, the implementation is straighforward and provides the most common operations on Vector. The implementation prioritises simplicity.

The Vector implementation provides just one public export, the Vector class. This class is written using the middleclass library.

The next section describes the implementation, then we provide a few sample usages of the Vector API. The final sections list any future plans, current limitations, known issues etc.
--]]

local root = (...):match("^(.*)%.[^.]+$")

local Class = require(root .. '.middleclass')

--- Vector class
-- (adapted from an older version I'd written)
local Vector = Class('Vector')

--- constructor
--@param x the x component of the vector
--@param y the y component of the vector
--@param z the z component of the vector
function Vector:initialize(x, y, z)
    self:set(x or 0, y or 0, z or 0)
end

--- set the x, y, z components of the vector
--@param x the x component of the vector
--@param y the y component of the vector
--@param z the z component of the vector
function Vector:set(x, y, z)
    self.x = x
    self.y = y
    self.z = z
end

--- copy the vector
function Vector:copy()
    return Vector(self.x, self.y, self.z)
end

--- tostring operator overloading
function Vector:__tostring()
    return 'Vector(' .. self.x .. ', ' .. self.y .. ', ' .. self.z .. ')'
end

--- add a vector to this vector using the lua operator overloading
--@param v the vector to add
function Vector:__add(v)
    return Vector(self.x + v.x, self.y + v.y, self.z + v.z)
end

--- subtract a vector from this vector using the lua operator overloading
--@param v the vector to subtract
function Vector:__sub(v)
    return Vector(self.x - v.x, self.y - v.y, self.z - v.z)
end

--- multiply this vector by a scalar using the lua operator overloading
--@param s the scalar to multiply
function Vector:__mul(s)
    return Vector(self.x * s, self.y * s, self.z * s)
end

--- divide this vector by a scalar using the lua operator overloading
--@param s the scalar to divide
function Vector:__div(s)
    return Vector(self.x / s, self.y / s, self.z / s)
end

--- get the magnitude of the vector
function Vector:mag()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

-- set the magnitude of the vector
--@param m the magnitude to set
function Vector:setMag(m)
    self:normalize()
    -- multiply by the magnitude
    self:set(self.x * m, self.y * m, self.z * m)
end

--- get the magnitude of the vector squared
function Vector:magSq()
    return self.x * self.x + self.y * self.y + self.z * self.z
end

--- get the heading of the vector
function Vector:heading()
    return math.atan2(self.y, self.x)
end

--- limit the magnitude of the vector, returns a new vector without modifying
-- the original
--@param max the maximum magnitude
--@return the limited vector (a new vector)
function Vector:limit(max)
    local limited = self:copy()
    if limited:magSq() > max * max then
        limited:normalize()
        limited = limited * max
    end
    return limited
end

--- dot product of this vector with another vector
--@param v the other vector
function Vector:dot(v)
    return self.x * v.x + self.y * v.y + self.z * v.z
end

--- cross product of this vector with another vector
--@param v the other vector
function Vector:cross(v)
    return Vector(
        self.y * v.z - self.z * v.y,
        self.z * v.x - self.x * v.z,
        self.x * v.y - self.y * v.x
    )
end

--- distance between this vector and another vector
--@param v the other vector
function Vector:dist(v)
    return (self - v):mag()
end

--- normalize the vector
function Vector:normalize()
    local m = self:mag()
    if m > 0 then
        self:set(self.x / m, self.y / m, self.z / m)
    end
end

--- equals operator overloading
--@param v the other vector
function Vector:__eq(v)
    return self.x == v.x and self.y == v.y and self.z == v.z
end

--- vector not equals operator overloading
--@param v the other vector
function Vector:__ne(v)
    return not (self == v)
end

--- vector unary minus operator overloading
function Vector:__unm()
    return Vector(-self.x, -self.y, -self.z)
end

--- vector unary plus operator overloading
function Vector:__uplus()
    return self:copy()
end

--- vector less than operator overloading
--@param v the other vector
function Vector:__lt(v)
    return self:magSq() < v:magSq()
end

--- vector less than or equal to operator overloading
--@param v the other vector
function Vector:__le(v)
    return self:magSq() <= v:magSq()
end

--- vector greater than operator overloading
--@param v the other vector
function Vector:__gt(v)
    return self:magSq() > v:magSq()
end

--- vector greater than or equal to operator overloading
--@param v the other vector
function Vector:__ge(v)
    return self:magSq() >= v:magSq()
end

--- create a random 2D vector
--@return a random 2D vector
function Vector.random2D()
    local angle = math.random() * math.pi * 2
    return Vector(math.cos(angle), math.sin(angle))
end

--- create a 2D vector from an angle and optional magnitude
--@param angle the angle in radians
--@param length the magnitude of the vector
--@return a 2D vector
function Vector.fromAngle(angle, length)
    local magnitude = length or 1
    return Vector(
        math.cos(angle) * magnitude,
        math.sin(angle) * magnitude
    )
end

--- create a random 3D vector
--@return a random 3D vector
function Vector.random3D()
    local angle = math.random() * math.pi * 2
    local vz = math.random() * 2 - 1
    local vx = math.sqrt(1 - vz * vz) * math.cos(angle)
    local vy = math.sqrt(1 - vz * vz) * math.sin(angle)
    return Vector(vx, vy, vz)
end

return Vector
