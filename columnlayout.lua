local module_name = ...
local root = assert(module_name:match("^(.*)%.columnlayout$"))

local Class = require(root .. '.middleclass')
local Layout = require(root .. '.layout')

local ColumnLayout = Class('ColumnLayout', Layout)

-- Constructor for the Layout class
function ColumnLayout:initialize(rect, config)
    Layout.initialize(self, rect, config)
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
