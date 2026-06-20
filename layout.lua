--- Base class of ne0luv Layout classes
-- `Layout` defines the layout as a container of UI components
--
-- @classmod Layout
local root = (...):match("^(.*)%.[^.]+$")

local Class = require(root .. '.middleclass')
local Panel = require(root .. '.panel')

-- Define the Layout class that extends the Panel class
local Layout = Class('Layout', Panel)

-- Constructor for the Layout class
function Layout:initialize(layoutConfig, displayConfig)
    Panel.initialize(self, layoutConfig, displayConfig)
    self.displayConfig = displayConfig or {}
end

-- Method to add a child component
function Layout:addChild(c)
    Panel.addChild(self, c)
    self:reflow()
end

function Layout:removeChild(c)
    Panel:removeChild(self, c)
    self:reflow()
end

--- set the position of the child based on layout
-- and the size of the children
function Layout:reflow()
end

function Layout:setX(x)
    self.rect:setX(x)
end

function Layout:setY(y)
    self.rect:setY(y)
end

-- Method to set the background color for the panel
function Layout:setBGColor(color)
    self.bgColor = color
end

return Layout
