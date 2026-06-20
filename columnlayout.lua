local root = (...):match("^(.*)%.[^.]+$")

local Class = require(root .. '.middleclass')
local Layout = require(root .. '.layout')

local ColumnLayout = Class('ColumnLayout', Layout)

-- Constructor for the Layout class
function ColumnLayout:initialize(layoutConfig, displayConfig)
    Layout.initialize(self, layoutConfig, displayConfig)
end

function ColumnLayout:reflow()
    local startPos = 0
    for _, child in ipairs(self.children) do
        child:setX(0)
        child:setY(startPos)
        startPos = startPos + child:getHeight()
    end
end

return ColumnLayout
