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
        bgColor = self.colors.bgSelect
        fgColor = self.colors.fgSelect
    else
        bgColor = self.colors.bg
        fgColor = self.colors.fg
    end
    if self.down then
        local temp = bgColor
        bgColor = fgColor
        fgColor = temp
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
    self.down = true
end

function Button:_mousereleased(x, y, button, istouch, presses)
    if self:isEnabled() then
        self.onActivate()
    end
    self.down = false
end

return Button
