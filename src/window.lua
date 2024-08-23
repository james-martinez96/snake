local M = {}

--- @return integer TILE_SIZE
--- @return integer TILE_X_COUNT
--- @return integer TILE_Y_COUNT
function M.setupWindow()
    local _, _, flags = love.window.getMode()
    local monitorWidth, monitorHeight = love.window.getDesktopDimensions(flags.display)
    local WINDOW_WIDTH = tonumber(monitorWidth)
    local WINDOW_HEIGHT = tonumber(monitorHeight)
    if WINDOW_WIDTH == nil or WINDOW_HEIGHT == nil then
        print("Error: monitor dimensions could not be determined")
    end

    local success = love.window.setMode(0, 0, { fullscreen = true })
    if not success then
        print("Failure")
    else
        print("Success")
    end

    local TILE_SIZE = 10

    local TILE_X_COUNT = math.floor(WINDOW_WIDTH / TILE_SIZE)
    local TILE_Y_COUNT = math.floor(WINDOW_HEIGHT / TILE_SIZE)

    return TILE_SIZE, TILE_X_COUNT, TILE_Y_COUNT
end

return M
