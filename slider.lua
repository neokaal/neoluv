local module_name = ...
local root = assert(module_name:match("^(.*)%.slider$"))

local Class = require(root .. '.middleclass')
local Panel = require(root .. '.panel')

-- Define the Slider class that extends the Panel class
local Slider = Class('Slider', Panel)

-- Constructor for the Slider class
function Slider:initialize(layoutConfig, displayConfig)
    Panel.initialize(self, layoutConfig, displayConfig)
    self.displayConfig = displayConfig or {}
    -- Default minValue is 0
    self.minValue = self.displayConfig.minValue or 0
    -- Default maxValue is 100
    self.maxValue = self.displayConfig.maxValue or 100
    -- Default currentValue is minValue
    self.currentValue = self.displayConfig.currentValue or self.minValue
    -- Default text color is white
    self.fgColor = self.displayConfig.fgColor or { 1, 1, 1, 1 }
    self.handleColor = self.displayConfig.handleColor or { 0.8, 0.8, 0.8, 1 }
    self.activeColor = self.displayConfig.activeColor or { 0.5, 0.5, 0.5, 1 }
    self.handleWidth = 10                                -- Width of the handle
    self.handleHeight = self:getCanvasRect():getHeight() -- Height of the handle
    self.handleX = self:calculateHandlePosition()        -- Local X position of the handle
    self.changeHandler = {}
end

-- Method to calculate the handle position based on the current value
function Slider:calculateHandlePosition()
    local canvasRect = self:getCanvasRect()
    local range = self.maxValue - self.minValue
    local fraction = (self.currentValue - self.minValue) / range
    return fraction * (canvasRect:getWidth() - self.handleWidth)
end

-- Method to update the current value based on the handle position
function Slider:updateCurrentValue()
    local canvasRect = self:getCanvasRect()
    local range = self.maxValue - self.minValue
    local fraction = self.handleX / (canvasRect:getWidth() - self.handleWidth)
    self.currentValue = self.minValue + fraction * range
    -- self.currentValue = math.floor(self.currentValue + 0.5)
    self:fireChangeHandlers()
end

function Slider:addChangeHandler(handler)
    table.insert(self.changeHandler, handler)
end

function Slider:fireChangeHandlers()
    for _, handler in ipairs(self.changeHandler) do
        handler(self.currentValue)
    end
end

-- remove handler
function Slider:removeChangeHandler(handler)
    for i, h in ipairs(self.changeHandler) do
        if h == handler then
            table.remove(self.changeHandler, i)
            break
        end
    end
end

-- Override the draw method
function Slider:_draw()
    local canvasRect = self:getCanvasRect()

    -- Draw the line
    love.graphics.setColor(self.fgColor)
    love.graphics.line(
        0, canvasRect:getHeight() / 2,
        canvasRect:getWidth(), canvasRect:getHeight() / 2
    )

    -- Draw the handle
    if self.dragging then
        love.graphics.setColor(self.activeColor)
    else
        love.graphics.setColor(self.handleColor)
    end
    love.graphics.rectangle('fill', self.handleX, 0, self.handleWidth, self.handleHeight)
end

-- Override the mousepressed method
function Slider:_mousepressed(x, y, button)
    local canvasRect = self:getCanvasRect()
    -- print("Slider:mousepressed [" .. x .. ", " .. y .. "]")
    if button == 1 and x >= self.handleX
        and x <= self.handleX + self.handleWidth
        and y >= 0 and y <= self.handleHeight then
        self.dragging = true
    else
        self.handleX = math.max(0, math.min(canvasRect:getWidth() - self.handleWidth, x))
        self.dragging = false
        self:updateCurrentValue()
    end
end

-- Override the mousemoved method
function Slider:_mousemoved(x, y, dx, dy)
    local canvasRect = self:getCanvasRect()
    -- print("Slider:mousemoved")
    if self.dragging then
        self.handleX = self.handleX + dx
        self.handleX = math.max(0,
            math.min(canvasRect:getWidth() - self.handleWidth, self.handleX))
        self:updateCurrentValue()
    end
end

-- Override the mousereleased method
function Slider:_mousereleased(x, y, button)
    -- print("Slider:mousereleased")
    if button == 1 then
        self.dragging = false
    end
end

return Slider
