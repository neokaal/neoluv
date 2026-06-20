local ne0luv = require('.')

local root
local statusText
local w, h
local samples = {}

local function addSample(samplePanel, name, description)
    if samplePanel == nil then
        error("sample panel is nil")
    end
    name = name or "noname"
    description = description or "none"

    table.insert(samples, {
        name = name,
        description = description,
        onActivate = function()
            samplePanel.show()
        end,
        onDeactivate = function()
            samplePanel.hide()
        end
    })
end

function love.load()
    love.window.setTitle('ne0luv panel refactor playground')
    w, h = love.graphics.getDimensions()
    root = ne0luv.RowLayout({
        size = { w = w, h = h },
    }, {
        bgColor = { 0.1, 0.1, 0.1, 0.85 }
    })
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

function love.keypressed(key)
    -- exit the application when escape is pressed
    if key == "escape" then
        love.event.quit()
    end
    root:keypressed(key)
end

local function createDefaultDemoPanel()
    local title = ne0luv.Text({
        size = { w = 280, h = 32 },
        margin = { 2, 10 },
        border = 1,
        padding = 2
    }, {
        text = 'Panel local coordinates demo',
        borderColor = { 0, 0, 0, 1 }
    })

    statusText = ne0luv.Text({
        size = { w = 280, h = 24 },
        margin = { 2, 10 },
        border = 1,
        padding = 2
    }, {
        text = 'Click the button or drag the slider'
    })

    local button = ne0luv.Button({
        size = { w = 180, h = 32 },
        margin = { 2, 10 },
        border = 1,
        padding = 2
    }, {
        text = 'Activate',
        onActivate = function()
            statusText:setText('Button activated')
        end
    })

    local slider = ne0luv.Slider({
        size = { w = 220, h = 24 },
        margin = { 2, 10 },
        border = 1,
        padding = 2
    }, {
        minValue = 0,
        maxValue = 100,
        currentValue = 25
    })

    slider:addChangeHandler(function(value)
        statusText:setText(string.format('Slider value: %.0f', value))
    end)

    local nestedRow = ne0luv.RowLayout({
        size = { w = 500, h = 32 },
    }, {
        bgColor = { 0.18, 0.18, 0.24, 0.9 }
    })

    local nestedLabel = ne0luv.Text({
        size = { w = 120, h = 32 },
        margin = { 2, 10 },
        border = 1,
        padding = 2
    }, {
        text = 'Nested row:'
    })

    local imgBtnPng = love.graphics.newImage('assets/images/img-button.png')
    local nestedImgButton = ne0luv.ImageButton({
        size = { w = 64, h = 32 },
    }, {
        image = imgBtnPng,
        normal = love.graphics.newQuad(0, 0, 64, 32, imgBtnPng),
        disabled = love.graphics.newQuad(64, 0, 64, 32, imgBtnPng),
        hover = love.graphics.newQuad(128, 0, 64, 32, imgBtnPng),
        down = love.graphics.newQuad(192, 0, 64, 32, imgBtnPng),
        onActivate = function()
            statusText:setText('Image button activated')
        end,
    })

    local nestedButton = ne0luv.Button({
        size = { w = 120, h = 32 },
        margin = { 2, 10 },
        border = 1,
        padding = 2
    }, {
        text = 'Nested button',
        onActivate = function()
            statusText:setText('image button toggled')
            nestedImgButton:setEnabled(not nestedImgButton:isEnabled())
        end
    })

    nestedRow:addChild(nestedLabel)
    nestedRow:addChild(nestedButton)
    nestedRow:addChild(nestedImgButton)

    local panelWithBorder = ne0luv.Panel({
        size = { w = 100, h = 100 },
        margin = { 2, 4 },
        border = { 3, 6 },
        padding = { 4, 8 }
    }, {
        borderColor = { 1, 0, 0, 1 },
        bgColor = { 0, 1, 0, 1 }
    })

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
    root:addChild(panelWithBorder)
end
