local neoluv = require('.')

local root
local statusText
local w, h
local samples = {}
local sidePanel
local sampleContainerPanel
local currentSamplePanel = nil
local currentSampleButton = nil

local function addSample(samplePanel, name, description)
    if samplePanel == nil then
        error("sample panel is nil")
    end
    name               = name or "noname"
    description        = description or "none"

    local sampleButton = neoluv.Button({
        size = { w = sidePanel:getWidth(), h = 32 },
        margin = { 2, 2 },
        border = 2,
        padding = 2,
        borderColor = { 0.1, 0.1, 0.1, 1 }
    }, {
        text = name,
        align = "center",
        onActivate = function(btn)
            if currentSamplePanel and currentSampleButton then
                currentSamplePanel:hide()
                currentSampleButton.displayConfig.borderColor = { 0.1, 0.1, 0.1, 1 }
            end
            currentSamplePanel = samplePanel
            currentSamplePanel:show()
            currentSampleButton = btn
            currentSampleButton.displayConfig.borderColor = { 1, 0, 0, 1 }
        end
    })

    sampleContainerPanel:addChild(samplePanel)
    samplePanel:hide()
    sidePanel:addChild(sampleButton)
    if currentSamplePanel == nil then
        currentSampleButton = sampleButton
        sampleButton.onActivate(sampleButton)
    end

    table.insert(samples, {
        name = name,
        description = description
    })
end

local function createSidePanel()
    return neoluv.ColumnLayout({
        size = { w = w / 3.0, h = h },
    }, {
        bgColor = { 0.1, 0.1, 0.1, 0.85 }
    })
end

local function createSampleContainerPanel()
    -- TODO: investigate why Panel doesn't work here.
    return neoluv.ColumnLayout({
        size = { w = w * 2.0 / 3.0, h = h },
    }, {
        bgColor = { 0.1, 0.1, 0.1, 0.85 }
    })
end

local function createTextLabel()
    return neoluv.Text({
        size = { w = 280, h = 32 },
        margin = { 2, 10 },
        border = 1,
        padding = 2
    }, {
        text = 'This is a simple text label',
        borderColor = { 0, 0, 0, 1 }
    })
end

local function createButton()
    return neoluv.Button({
        size = { w = 180, h = 32 },
        margin = { 2, 10 },
        border = 1,
        padding = 2
    }, {
        text = 'Activate (0)',
        onActivate = function(btn)
            btn.clickCount = (btn.clickCount or 0) + 1
            btn.displayConfig.text = 'Activate (' .. tostring(btn.clickCount) .. ')'
        end
    })
end

function love.load()
    love.window.setTitle('ne0luv panel refactor playground')
    w, h = love.graphics.getDimensions()
    root = neoluv.RowLayout({
        size = { w = w, h = h },
    }, {
        bgColor = { 0.1, 0.1, 0.1, 0.85 }
    })

    sidePanel = createSidePanel()
    sampleContainerPanel = createSampleContainerPanel()
    root:addChild(sidePanel)
    root:addChild(sampleContainerPanel)

    addSample(createTextLabel(), "Text Label")
    addSample(createButton(), "Simple Button")
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
    local slider = neoluv.Slider({
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

    local nestedRow = neoluv.RowLayout({
        size = { w = 500, h = 32 },
    }, {
        bgColor = { 0.18, 0.18, 0.24, 0.9 }
    })

    local nestedLabel = neoluv.Text({
        size = { w = 120, h = 32 },
        margin = { 2, 10 },
        border = 1,
        padding = 2
    }, {
        text = 'Nested row:'
    })

    local imgBtnPng = love.graphics.newImage('assets/images/img-button.png')
    local nestedImgButton = neoluv.ImageButton({
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

    local nestedButton = neoluv.Button({
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

    local panelWithBorder = neoluv.Panel({
        size = { w = 100, h = 100 },
        margin = { 2, 4 },
        border = { 3, 6 },
        padding = { 4, 8 }
    }, {
        borderColor = { 1, 0, 0, 1 },
        bgColor = { 0, 1, 0, 1 }
    })

    root = neoluv.ColumnLayout({
        size = { w = w, h = h },
    }, {
        bgColor = { 0.1, 0.1, 0.1, 0.85 }
    })

    root:addChild(statusText)
    root:addChild(nestedRow)
    root:addChild(slider)
    root:addChild(panelWithBorder)
end
