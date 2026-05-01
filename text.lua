--- text.lua - A panel class that displays a single line of text
--
-- date: 17/02/2024
-- author: Abhishek Mishra

-- Define the Text class that extends the Panel class
local module_name = ...
local root = assert(module_name:match("^(.*)%.text$"))

local Class = require(root .. '.middleclass')
local Panel = require(root .. '.panel')

local Text = Class('Text', Panel)

-- Constructor for the Text class
function Text:initialize(layoutConfig, displayConfig)
    Panel.initialize(self, layoutConfig, displayConfig)
    self.displayConfig = displayConfig or {}
    self.fgColor = self.displayConfig.fgColor or { 1, 1, 1, 1 }      -- Default text color is white
    self.font = self.displayConfig.font or love.graphics.newFont(14) -- Default font size is 14
    self.displayText = self.displayConfig.text or ""                 -- Default text is an empty string
    self.align = self.displayConfig.align or "left"                  -- Default alignment is left
    self._text = love.graphics.newText(self.font, self.displayText)  -- Create the love2d text object
end

-- Method to set the text
function Text:setText(text)
    self.displayText = text
    self._text:set(text) -- Update the love2d text object
end

-- Set the text alignment
function Text:setAlignment(align)
    self.align = align
end

-- Override the draw method
function Text:_draw()
    local canvasRect = self:getCanvasRect()
    love.graphics.setColor(self.fgColor)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.displayText, 0, 0, canvasRect:getWidth(), self.align)
end

return Text
