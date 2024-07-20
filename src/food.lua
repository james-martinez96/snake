local M = {}

---@param gridXCount integer
---@param gridYCount integer
---@param snakeSegments table
---@return table|nil
function M.moveFood(gridXCount, gridYCount, snakeSegments)
    local possibleFoodPositions = {}

    for foodX = 1, gridXCount do
        for foodY = 1, gridYCount do
            local possible = true

            for segmentIndex, segment in ipairs(snakeSegments) do
                if foodX == segment.x and foodY == segment.y then
                    possible = false
                    break
                end
            end

            if possible then
                table.insert(possibleFoodPositions, { x = foodX, y = foodY })
            end
        end
    end

    if #possibleFoodPositions == 0 then
        return nil
    end

    local foodPosition = possibleFoodPositions[love.math.random(#possibleFoodPositions)]
    return foodPosition
end

return M
