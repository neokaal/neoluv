--- Base class for ne0luv UI panels.
-- `Panel` defines the canonical drawing and hit-testing contract for UI
-- components in ne0luv.
--
-- Behaviour:
--
-- - A `Panel` owns a `Rect` that defines its position and bounds.
-- - A `Panel` constructor accepts either a `Rect` instance or a rect
--   specification table with named fields `w`, `h`, and optional `x`, `y`.
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

local function _normalize_rect(rect)
    if rect == nil then
        return Rect(0, 0, PANEL_DEFAULT_WIDTH, PANEL_DEFAULT_HEIGHT)
    end

    if type(rect) ~= 'table' then
        error("Panel rect must be a Rect or a table with w, h, and optional x, y", 3)
    end

    if rect.isInstanceOf and rect:isInstanceOf(Rect) then
        return rect
    end

    if rect.w == nil or rect.h == nil then
        error("Panel rect table must define w and h", 3)
    end

    return Rect(rect.x or 0, rect.y or 0, rect.w, rect.h)
end

-- Define the Panel class
local Panel = Class('Panel')

--- Create a new panel.
-- @tparam[opt] Rect|table rect Bounds for the panel. Accepts either a `Rect`
-- instance or a table `{ w = ..., h = ..., x = ..., y = ... }`. `w` and `h`
-- are required; `x` and `y` default to `0`. Defaults to a 100x100 panel at
-- `(0, 0)`.
function Panel:initialize(rect)
    self.rect = _normalize_rect(rect)
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
