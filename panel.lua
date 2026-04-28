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
    self.displayConfig = displayConfig or {}
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
        love.graphics.translate(self:getX(), self:getY())
        self:_draw()
        love.graphics.pop()
    end
end

function Panel:_draw()
    -- Code to draw the panel
end

function Panel:keypressed(key)
    -- Code to handle key press
end

--- Convert a point from parent-space coordinates into panel-local
-- coordinates.
function Panel:toLocalPoint(x, y)
    return x - self:getX(), y - self:getY()
end

--- Return whether a panel-local point is inside the panel bounds.
function Panel:containsLocalPoint(x, y)
    if x == nil or y == nil then
        return false
    end

    return x >= 0 and x <= self:getWidth()
        and y >= 0 and y <= self:getHeight()
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

function Panel:getHeight()
    return self.rect:getHeight()
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

return Panel
