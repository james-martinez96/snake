local M = {}

---@return integer
---@return integer
---@return integer
function M.setupWindow()
    local _, _, flags = love.window.getMode()
    local monitorWidth, monitorHeight = love.window.getDesktopDimensions(flags.display)
    local width = tonumber(monitorWidth)
    local height = tonumber(monitorHeight)
    if width == nil or height == nil then
        print("Error: monitor dimensions could not be determined")
    end

    local success = love.window.setMode(0, 0, { fullscreen = true })
    if not success then
        print("Failure")
    else
        print("Success")
    end

    local cellSize = 15

    local gridXCount = math.floor(width / cellSize)
    local gridYCount = math.floor(height / cellSize)

    return cellSize, gridXCount, gridYCount
end

return M
