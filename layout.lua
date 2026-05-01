--- Base class of ne0luv Layout classes
-- `Layout` defines the layout as a container of UI components
--
-- @classmod Layout
local module_name = ...
local root = assert(module_name:match("^(.*)%.layout$"))

local Class = require(root .. '.middleclass')
local Panel = require(root .. '.panel')

-- Define the Layout class that extends the Panel class
local Layout = Class('Layout', Panel)

-- Constructor for the Layout class
function Layout:initialize(layoutConfig, displayConfig)
    Panel.initialize(self, layoutConfig, displayConfig)
    self.displayConfig = displayConfig or {}
    -- -- Default layout is row
    -- self.layout = self.displayConfig.layout or 'row'
    -- Default fill color is black
    self.bgColor = self.displayConfig.bgColor or { 0, 0, 0, 1 }
    -- Initialize an empty table for child components
    self.children = {}
end

-- Method to add a child component
function Layout:addChild(c)
    table.insert(self.children, c)

    -- Set the parent of the child to this layout
    c:setParent(self)

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

-- Get children
function Layout:getChildren()
    return self.children
end

-- Method to set the background color for the panel
function Layout:setBGColor(color)
    self.bgColor = color
end

-- show method
function Layout:show()
    Panel.show(self)
    -- Iterate over child components and show them
    for _, child in ipairs(self.children) do
        child:show()
    end
end

-- hide method
function Layout:hide()
    Panel.hide(self)
    -- Iterate over child components and hide them
    for _, child in ipairs(self.children) do
        child:hide()
    end
end

-- Override the _draw method
function Layout:_draw()
    local canvasRect = self:getCanvasRect()
    -- Draw the background
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle('fill', 0, 0, canvasRect:getWidth(), canvasRect:getHeight())
    -- Iterate over child components and draw them
    for _, child in ipairs(self.children) do
        child:draw()
    end
end

-- Override the update method
function Layout:update(dt)
    -- Iterate over child components and update them
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

-- Override the keypressed method
function Layout:keypressed(key)
    -- Iterate over child components and pass the keypress event
    for _, child in ipairs(self.children) do
        child:keypressed(key)
    end
end

-- Override the mousepressed method
function Layout:_mousepressed(x, y, button, istouch, presses)
    -- print("Layout:_mousepressed [" .. x .. ", " .. y .. "]")
    -- Iterate over child components and pass the mousepress event
    for _, child in ipairs(self.children) do
        child:mousepressed(x, y, button, istouch, presses)
    end
end

-- Override the mousereleased method
function Layout:_mousereleased(x, y, button, istouch, presses)
    -- Iterate over child components and pass the mouserelease event
    for _, child in ipairs(self.children) do
        child:mousereleased(x, y, button, istouch, presses)
    end
end

-- Override the mousemoved method
function Layout:_mousemoved(x, y, dx, dy, istouch)
    -- print("Layout:_mousemoved [" .. x .. ", " .. y .. "]")
    -- Iterate over child components and pass the mousemove event
    for _, child in ipairs(self.children) do
        child:mousemoved(x, y, dx, dy, istouch)
    end
end

-- Override the mouseout method
function Layout:_mouseout()
    -- Iterate over child components and pass the mouseout event
    for _, child in ipairs(self.children) do
        child:_mouseout()
    end
end

return Layout
