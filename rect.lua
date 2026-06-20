local root = (...):match("^(.*)%.[^.]+$")

local Class = require(root .. '.middleclass')
local Vector = require(root .. '.vector')

local Rect = Class('Rect')

function Rect:initialize(x, y, w, h)
    self.pos = Vector(x, y)
    self.dim = Vector(w, h)
end

function Rect:contains(x, y)
    if x == nil or y == nil then
        return false
    end

    return (x >= self.pos.x and x <= self.pos.x + self.dim.x
        and y >= self.pos.y and y <= self.pos.y + self.dim.y)
end

function Rect:getWidth()
    return self.dim.x
end

function Rect:getHeight()
    return self.dim.y
end

function Rect:getX()
    return self.pos.x
end

function Rect:getY()
    return self.pos.y
end

function Rect:setX(x)
    self.pos.x = x
end

function Rect:setY(y)
    self.pos.y = y
end

function Rect:setWidth(w)
    self.dim.x = w
end

function Rect:setHeight(h)
    self.dim.y = h
end

return Rect
