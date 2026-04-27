local module_name = ...
local root = assert(module_name:match("^(.*)%.rowlayout$"))

local Class = require(root .. '.middleclass')
local Layout = require(root .. '.layout')

local RowLayout = Class('RowLayout', Layout)

-- Constructor for the Layout class
function RowLayout:initialize(rect, config)
    Layout.initialize(self, rect, config)
end

function RowLayout:reflow()
    local startPos = 0
    for _, child in ipairs(self.children) do
        child:setX(startPos)
        child:setY(0)
        startPos = startPos + child:getWidth()
    end
end

return RowLayout
