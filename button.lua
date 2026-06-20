--- button.lua - A simple button class
--
-- date: 17/02/2024
-- author: Abhishek Mishra

--- Button class
local root = (...):match("^(.*)%.[^.]+$")

local Class = require(root .. '.middleclass')
local Panel = require(root .. '.panel')

local Button = Class('Button', Panel)

--- constructor
-- @param layoutConfig layout configuration for the button
-- @param displayConfig display configuration for the button
function Button:initialize(layoutConfig, displayConfig)
    Panel.initialize(self, layoutConfig, displayConfig)
    self.displayConfig = displayConfig or {}
    self.displayConfig.text = self.displayConfig.text or ""
    self.onActivate = self.displayConfig.onActivate or function(button) end
    -- self.text = love.graphics.newText(love.graphics.getFont(), self.displayText)
    self.displayConfig.font = self.displayConfig.font or love.graphics.getFont()
    self.displayConfig.align = self.displayConfig.align or "left"
    self.displayConfig.bgColor = self.displayConfig.bgColor or { 0.2, 0.2, 0.2, 1 }
    self.displayConfig.fgColor = self.displayConfig.fgColor or { 1, 1, 1, 1 }
    self.displayConfig.bgSelectColor = self.displayConfig.bgSelectColor or self.displayConfig.bgColor
    self.displayConfig.fgSelectColor = self.displayConfig.fgSelectColor or self.displayConfig.fgColor
    self.displayConfig.bgSelectColor = self.displayConfig.bgSelectColor or { 0.35, 0.35, 0.35, 1 }
    self.displayConfig.fgSelectColor = self.displayConfig.fgSelectColor or self.colors.fg

    -- state
    self.enabled = self.displayConfig.enabled or true
    self.down = false
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

function Button:setEnabled(enabled)
    self.enabled = enabled and true or false
    if not self.enabled then
        self:setSelected(false)
    end
end

function Button:isEnabled()
    return self.enabled
end

--- draw the button
function Button:_draw()
    local canvasRect = self:getCanvasRect()
    local bgColor, fgColor
    if self:isSelected() then
        bgColor = self.displayConfig.bgSelectColor
        fgColor = self.displayConfig.fgSelectColor
    else
        bgColor = self.displayConfig.bgColor
        fgColor = self.displayConfig.fgColor
    end
    if self.down then
        local temp = bgColor
        bgColor = fgColor
        fgColor = temp
    end
    love.graphics.setColor(bgColor)
    love.graphics.rectangle('fill', 0, 0, canvasRect:getWidth(), canvasRect:getHeight())
    love.graphics.setColor(fgColor)
    love.graphics.setFont(self.displayConfig.font)
    love.graphics.printf(self.displayConfig.text, 0, 0, canvasRect:getWidth(), self.displayConfig.align)
end

function Button:_mouseout()
    self:setSelected(false)
end

function Button:_mousemoved(x, y, dx, dy, istouch)
    self:setSelected(true)
end

function Button:_mousepressed(x, y, button, istouch, presses)
    self.down = true
end

function Button:_mousereleased(x, y, button, istouch, presses)
    if self:isEnabled() then
        self.onActivate(self)
    end
    self.down = false
end

return Button
