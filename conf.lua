function love.conf(t)
    t.window.title       = 'Neoluv Demo'

    -- Set identity to ensure a stable save directory for love.filesystem
    t.identity           = 'neoluv'

    -- Added high dpi handling for ios/android devices
    t.window.highdpi     = true
    t.window.usedpiscale = true

    -- Required for Android to handle rotation/resizing
    t.window.resizable   = true

    -- set the window width and height
    t.window.width       = 800
    t.window.height      = 600


    -- enable console (enabling this will crash love2d if run from vscode)
    -- only run from terminal when this is enabled
    t.console = true

    -- disable unused modules for performance
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = true
end
