local ne0luv = require('.')

local root
local statusText

function love.load()
    love.window.setTitle('ne0luv panel refactor playground')
    local w, h
    w, h = love.graphics.getDimensions()

    local title = ne0luv.Text({
        size = { w = 280, h = 24 },
    }, {
        text = 'Panel local coordinates demo'
    })

    statusText = ne0luv.Text({
        size = { w = 280, h = 24 },
    }, {
        text = 'Click the button or drag the slider'
    })

    local button = ne0luv.Button({
        size = { w = 180, h = 32 },
    }, {
        text = 'Activate',
        onActivate = function()
            statusText:setText('Button activated')
        end
    })

    local slider = ne0luv.Slider({
        size = { w = 220, h = 24 },
    }, {
        minValue = 0,
        maxValue = 100,
        currentValue = 25
    })

    slider:addChangeHandler(function(value)
        statusText:setText(string.format('Slider value: %.0f', value))
    end)

    local nestedRow = ne0luv.RowLayout({
        size = { w = 280, h = 32 },
    }, {
        bgColor = { 0.18, 0.18, 0.24, 0.9 }
    })

    local nestedLabel = ne0luv.Text({
        size = { w = 120, h = 32 },
    }, {
        text = 'Nested row:'
    })

    local nestedButton = ne0luv.Button({
        size = { w = 120, h = 32 },
    }, {
        text = 'Nested button',
        onActivate = function()
            statusText:setText('Nested row button activated')
        end
    })

    nestedRow:addChild(nestedLabel)
    nestedRow:addChild(nestedButton)

    root = ne0luv.ColumnLayout({
        size = { w = w, h = h },
    }, {
        bgColor = { 0.1, 0.1, 0.1, 0.85 }
    })

    root:addChild(title)
    root:addChild(statusText)
    root:addChild(nestedRow)
    root:addChild(button)
    root:addChild(slider)
end

function love.update(dt)
    root:update(dt)
end

function love.draw()
    root:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    root:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    root:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    root:mousemoved(x, y, dx, dy, istouch)
end
