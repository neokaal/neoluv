--- Button class
local module_name = ...
local root = assert(module_name:match("^(.*)%.imagebutton$"))

local Class = require(root .. '.middleclass')
local Button = require(root .. '.button')

local ImageButton = Class('ImageButton', Button)

function ImageButton:initialize(layoutConfig, displayConfig)
    Button.initialize(self, layoutConfig, displayConfig)
    self.images = {
        image = self.displayConfig.image,
        normal = self.displayConfig.normal,
        hover = self.displayConfig.hover or self.displayConfig.normal,
        down = self.displayConfig.down or self.displayConfig.normal
    }
    print(self.images.hover)
end

function ImageButton:_draw()
    local canvasRect = self:getCanvasRect()
    if self.down then
        -- print(self.down)
        love.graphics.draw(self.images.image, self.images.down, 0, 0)
    elseif self.hover then
        love.graphics.draw(self.images.image, self.images.hover, 0, 0)
    else
        love.graphics.draw(self.images.image, self.images.normal, 0, 0)
    end
end

function ImageButton:_mousereleased(x, y, button, istouch, presses)
    Button._mousereleased(self, x, y, button, istouch, presses)
end

return ImageButton
