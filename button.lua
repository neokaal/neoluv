--- button.lua - A simple button class
--
-- date: 17/02/2024
-- author: Abhishek Mishra

--- Button class
local module_name = ...
local root = assert(module_name:match("^(.*)%.button$"))

local Class = require(root .. '.middleclass')
local Panel = require(root .. '.panel')

local Button = Class('Button', Panel)

--- a counter to keep track of the number of buttons created
Button.static.idCounter = 0

--- constructor
-- @param layoutConfig layout configuration for the button
-- @param displayConfig display configuration for the button
function Button:initialize(layoutConfig, displayConfig)
    Panel.initialize(self, layoutConfig, displayConfig)
    self.displayConfig = displayConfig or {}
    Button.idCounter = Button.idCounter + 1
    self.id = 'Button' .. Button.idCounter
    self.displayText = self.displayConfig.text or ""
    self.onActivate = self.displayConfig.onActivate or function() end
    -- self.text = love.graphics.newText(love.graphics.getFont(), self.displayText)
    self.font = self.displayConfig.font or love.graphics.getFont()
    self.align = self.displayConfig.align or "left"
    self.colors = {
        bg = self.displayConfig.bgColor or { 0.2, 0.2, 0.2, 1 },
        fg = self.displayConfig.fgColor or { 1, 1, 1, 1 },
        bgSelect = self.displayConfig.bgSelectColor or self.displayConfig.bgColor,
        fgSelect = self.displayConfig.fgSelectColor or self.displayConfig.fgColor
    }
    self.colors.bgSelect = self.colors.bgSelect or { 0.35, 0.35, 0.35, 1 }
    self.colors.fgSelect = self.colors.fgSelect or self.colors.fg
end

function Button:toggleSelect()
    self.select = not self.select
end

function Button:isSelected()
    return self.select
end

function Button:setSelected(selected)
    if selected == nil then
        selected = true
    end
    self.select = selected
end

--- draw the button
function Button:_draw()
    local canvasRect = self:getCanvasRect()
    local bgColor, fgColor
    if self:isSelected() then
        bgColor = self.colors.bgSelect
        fgColor = self.colors.fgSelect
    else
        bgColor = self.colors.bg
        fgColor = self.colors.fg
    end
    love.graphics.setColor(bgColor)
    love.graphics.rectangle('fill', 0, 0, canvasRect:getWidth(), canvasRect:getHeight())
    love.graphics.setColor(fgColor)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.displayText, 0, 0, canvasRect:getWidth(), self.align)
end

function Button:_mouseout()
    self:setSelected(false)
end

function Button:_mousemoved(x, y, dx, dy, istouch)
    self:setSelected(true)
end

function Button:_mousepressed(x, y, button, istouch, presses)
    self.onActivate()
end

return Button
