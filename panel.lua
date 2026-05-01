--- Base class for ne0luv UI panels.
-- `Panel` defines the canonical drawing and hit-testing contract for UI
-- components in ne0luv.
--
-- Behaviour:
--
-- - A `Panel` owns a `Rect` that defines its resolved position and bounds.
-- - A `Panel` constructor accepts either a layout config table with
--   `position = { x = ..., y = ... }` and `size = { w = ..., h = ... }`, or
--   a `Rect` instance.
-- - The `Rect` position and size are accessed through the `Rect`
--   getter/setter API.
-- - A `Panel` is visible when `shown == true`.
-- - `Panel:draw()` manages Love2D graphics state for the panel.
-- - Before calling `Panel:_draw()`, `Panel:draw()` translates the Love2D
--   transform to the panel origin.
-- - `Panel:_draw()` renders in panel-local coordinates, with the panel's
--   top-left at `(0, 0)`.
-- - `Panel` does not apply clipping by default.
-- - Public mouse handlers accept coordinates in the parent panel's coordinate
--   space.
-- - `Panel` converts parent-space mouse coordinates to panel-local
--   coordinates before calling underscored mouse handlers.
-- - Panel bounds are used for hit testing in panel-local coordinates.
-- - `Panel:mousepressed()` forwards to `Panel:_mousepressed()` only when the
--   press is inside the panel bounds.
-- - `Panel:mousereleased()` forwards to `Panel:_mousereleased()` only when the
--   release is inside the panel bounds.
-- - `Panel:mousemoved()` forwards to `Panel:_mousemoved()` when the pointer is
--   inside the panel bounds; otherwise it calls `Panel:_mouseout()`.
-- - Hidden panels do not draw.
-- - Hidden panels ignore mouse input.
--
-- Out of scope for the base `Panel` contract in the current implementation:
--
-- - clipping
-- - child management
-- - parent-relative input reconciliation
-- - input capture
--
-- @classmod Panel
local module_name = ...
local root = assert(module_name:match("^(.*)%.panel$"))

local Class = require(root .. '.middleclass')
local Rect = require(root .. '.rect')

-- Default values for the panel
local PANEL_DEFAULT_WIDTH = 100
local PANEL_DEFAULT_HEIGHT = 100

local function _normalize_layout_config(layoutConfig)
    if layoutConfig == nil then
        return Rect(0, 0, PANEL_DEFAULT_WIDTH, PANEL_DEFAULT_HEIGHT)
    end

    if type(layoutConfig) ~= 'table' then
        error("Panel layoutConfig must be a Rect or a table with position and size", 3)
    end

    if layoutConfig.isInstanceOf and layoutConfig:isInstanceOf(Rect) then
        return layoutConfig
    end

    local position = layoutConfig.position or { x = 0, y = 0 }
    local size = layoutConfig.size

    if type(position) ~= 'table' then
        error("Panel layoutConfig.position must be a table with numeric x and y", 3)
    end

    if type(size) ~= 'table' then
        error("Panel layoutConfig.size must be a table with numeric w and h", 3)
    end

    if type(position.x) ~= 'number' or type(position.y) ~= 'number' then
        error("Panel layoutConfig.position must define numeric x and y", 3)
    end

    if type(size.w) ~= 'number' or type(size.h) ~= 'number' then
        error("Panel layoutConfig.size must define numeric w and h", 3)
    end

    return Rect(position.x, position.y, size.w, size.h)
end


local Quad = Class('Quad')

function Quad.static:normalize_quad(layoutConfig, attr)
    local value = Quad(0)
    if (layoutConfig and layoutConfig[attr]
            and type(layoutConfig[attr]) == "number") then
        value = Quad(layoutConfig[attr])
    end
    if (layoutConfig and layoutConfig[attr]
            and type(layoutConfig[attr]) == "table") then
        value = Quad(unpack(layoutConfig[attr]))
    end
    return value
end

function Quad:initialize(n, e, s, w)
    self.n = n or 0
    self.e = e or self.n
    self.w = w or self.e
    self.s = s or self.n
end

-- Define the Panel class
local Panel = Class('Panel')

--- Create a new panel.
-- @tparam[opt] Rect|table layoutConfig Layout configuration for the panel.
-- Accepts either a canonical layout config
-- `{ position = { x = ..., y = ... }, size = { w = ..., h = ... } }`, or a
-- `Rect` instance. Defaults to a 100x100 panel at `(0, 0)`.
-- @tparam[opt] table displayConfig Display configuration reserved for
-- subclasses.
function Panel:initialize(layoutConfig, displayConfig)
    self.rect = _normalize_layout_config(layoutConfig)
    self.margin = Quad:normalize_quad(layoutConfig, 'margin')
    self.border = Quad:normalize_quad(layoutConfig, 'border')
    self.padding = Quad:normalize_quad(layoutConfig, 'padding')

    self.displayConfig = displayConfig or {}
    if not self.displayConfig.borderColor then
        self.displayConfig.borderColor = { 0, 0, 0, 1 }
    end
    if not self.displayConfig.bgColor then
        self.displayConfig.bgColor = { 0, 0, 0, 0.1 }
    end
    self.parent = nil
    self.shown = true
end

function Panel:setParent(parent)
    self.parent = parent
end

function Panel:getParent()
    return self.parent
end

-- Lifecycle methods
function Panel:show()
    self.shown = true
end

function Panel:hide()
    self.shown = false
end

function Panel:update(dt)
    -- Code to update the panel
end

--- Draw the panel in its local coordinate space.
-- `Panel:draw()` translates the Love2D transform to the panel origin before
-- calling `Panel:_draw()`.
function Panel:draw()
    if self.shown then
        love.graphics.push()

        -- translate to window position
        love.graphics.translate(self:getX(), self:getY())
        love.graphics.setColor({ 1, 1, 1, 0.4 })
        love.graphics.rectangle('fill', 0, 0, self:getWidth(), self:getHeight())

        -- translate to the position plus the margin
        love.graphics.translate(self.margin.w, self.margin.n)

        -- draw the border
        love.graphics.setColor(self.displayConfig.borderColor)
        -- north border
        love.graphics.rectangle('fill',
            0, 0,
            self:getWidth() - self.margin.w - self.margin.e - self.border.e, self.border.n)
        -- east border
        love.graphics.rectangle('fill',
            self:getWidth() - self.margin.w - self.margin.e - self.border.e, 0,
            self.border.e, self:getHeight() - self.margin.n - self.margin.s)
        -- -- west border
        love.graphics.rectangle('fill',
            0, 0,
            self.border.w, self:getHeight() - self.margin.n - self.margin.s)
        -- -- south border
        love.graphics.rectangle('fill',
            0, self:getHeight() - self.margin.n - self.margin.s - self.border.s,
            self:getWidth() - self.margin.e - self.margin.w - self.border.e, self.border.s)

        -- translate by the border
        love.graphics.translate(self.border.w, self.border.n)

        -- draw the background in the inner drawing area
        love.graphics.setColor(self.displayConfig.bgColor)
        love.graphics.rectangle('fill', 0, 0, self:getInnerWidth() + self.padding.w + self.padding.e,
            self:getInnerHeight() + self.padding.n + self.padding.s)

        -- translate by the padding
        love.graphics.translate(self.padding.w, self.padding.n)

        -- call the content drawing
        self:_draw()

        love.graphics.pop()
    end
end

--- Code to draw the panel
function Panel:_draw()
end

function Panel:keypressed(key)
    -- Code to handle key press
end

--- Convert a point from parent-space coordinates into panel-local
-- coordinates.
function Panel:toLocalPoint(x, y)
    return x - self:getX() - self.margin.w - self.border.w - self.padding.w,
        y - self:getY() - self.margin.n - self.border.n - self.padding.n
end

--- Return whether a panel-local point is inside the panel bounds.
function Panel:containsLocalPoint(x, y)
    if x == nil or y == nil then
        return false
    end

    return x >= 0 and x <= self:getInnerWidth()
        and y >= 0 and y <= self:getInnerHeight()
end

function Panel:mousepressed(x, y, button, istouch, presses)
    if not self.shown then
        return
    end

    local localX, localY = self:toLocalPoint(x, y)
    if self:containsLocalPoint(localX, localY) then
        self:_mousepressed(localX, localY, button, istouch, presses)
    end
end

function Panel:_mousepressed(x, y, button, istouch, presses)
end

function Panel:mousereleased(x, y, button, istouch, presses)
    if not self.shown then
        return
    end

    local localX, localY = self:toLocalPoint(x, y)
    if self:containsLocalPoint(localX, localY) then
        self:_mousereleased(localX, localY, button, istouch, presses)
    end
end

function Panel:_mousereleased(x, y, button, istouch, presses)
end

function Panel:mousemoved(x, y, dx, dy, istouch)
    if not self.shown then
        return
    end

    local localX, localY = self:toLocalPoint(x, y)
    if self:containsLocalPoint(localX, localY) then
        self:_mousemoved(localX, localY, dx, dy, istouch)
    else
        self:_mouseout()
    end
end

function Panel:_mousemoved(x, y, dx, dy, istouch)
end

function Panel:_mouseout()
end

function Panel:getWidth()
    return self.rect:getWidth()
end

function Panel:getInnerWidth()
    return (
        self:getWidth()
        - self.margin.e - self.margin.w
        - self.border.e - self.border.w
        - self.padding.e - self.padding.w
    )
end

function Panel:getHeight()
    return self.rect:getHeight()
end

function Panel:getInnerHeight()
    return (
        self:getHeight()
        - self.margin.n - self.margin.s
        - self.border.n - self.border.s
        - self.padding.n - self.padding.s
    )
end

function Panel:getX()
    return self.rect:getX()
end

function Panel:getY()
    return self.rect:getY()
end

function Panel:setX(x)
    self.rect:setX(x)
end

function Panel:setY(y)
    self.rect:setY(y)
end

function Panel:setMargin(n, e, s, w)
    self.margin = Quad(n, e, s, w)
end

function Panel:getMargin()
    return self.margin
end

function Panel:setBorder(n, e, s, w)
    self.border = Quad(n, e, s, w)
end

function Panel:getBorder()
    return self.border
end

function Panel:setPadding(n, e, s, w)
    self.padding = Quad(n, e, s, w)
end

function Panel:getPadding()
    return self.padding
end

return Panel
