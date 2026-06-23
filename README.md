# Neoluv

Reusable UI, math, and utility components for Love2D.

Neoluv is a collection of reusable UI, layout, math, and utility components for Love2D. It aims to provide practical building blocks for games and applications while remaining lightweight and composable.

The components are implemented as reusable classes using the excellent [middleclass](https://github.com/kikito/middleclass) library.

## Documentation

API docs in source files use [LDoc](https://lunarmodules.github.io/ldoc/manual/manual.md.html) format.

# Vector

The `Vector` module in `vector.lua` implments a simple Vector API similar to the
`Vector` API in `p5.js` [p5.Vector](https://p5js.org/reference/p5/p5.Vector/)

# UI

## Rect

Simple utility class that represents a rectangular area initialized with four arguments `x`, `y`, `w`, `h`. Internally these are represented by two vectors - one for position and one for dimensions.

## Panel

- The `Panel` class is the parent class of all UI classes.
- Each `Panel` owns a `Rect` that defines its resolved position and bounds.
- Panel constructors use a two-argument shape: `Panel(layoutConfig, displayConfig)`.
- `layoutConfig` describes where and how large the panel is. The phase-one form is `{ position = { x = 10, y = 10 }, size = { w = 50, h = 50 } }`.
- Panel constructors also accept a `Rect` instance.
- `displayConfig` is reserved for component-specific display and behavior options.
- `Panel:draw()` translates the Love2D transform to the panel origin before drawing.
- Subclasses implement `_draw()` in panel-local coordinates, with `(0, 0)` at the panel's top-left.
- Public mouse handlers receive coordinates in parent space and convert them to panel-local coordinates before calling underscored mouse handlers.
- Each `Panel` can have a parent panel. The top-level `Panel` has no parent.
- By default, `Panel` does not apply clipping.
- Mouse callbacks use panel-local bounds for hit testing.
- Hidden panels do not draw and ignore mouse input.

## Layout

- `Layout` is the base container class for layouts.
- `RowLayout` and `ColumnLayout` are the concrete layout classes intended for direct use.
- Layouts position child panels in layout-local coordinates.
- `addChild()` attaches a child panel, sets its parent, and updates the layout.
- `RowLayout` arranges children horizontally in insertion order.
- `ColumnLayout` arranges children vertically in insertion order.
