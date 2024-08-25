--- Food
--- A class to mange differnt types of Food.
--- @class Food
--- @field TILE_X_COUNT integer
--- @field TILE_Y_COUNT integer
--- @field TILE_SIZE integer
local Food = {}
Food.__index = Food

--- Creates a new Food instance.
--- @param TILE_X_COUNT integer The number of tiles along the X axis.
--- @param TILE_Y_COUNT integer The number of tiles along the Y axis.
--- @param TILE_SIZE integer The size of each tile.
function Food:new(TILE_X_COUNT, TILE_Y_COUNT, TILE_SIZE)
    local instance = setmetatable({}, Food)
    instance.TILE_X_COUNT = TILE_X_COUNT
    instance.TILE_Y_COUNT = TILE_Y_COUNT
    instance.TILE_SIZE = TILE_SIZE
    instance.x = nil
    instance.y = nil
    return instance
end

--- @param snakeSegments table The table of segmemts representing the snake.
--- @return table|nil A table with x, y of the Food.
function Food:move(snakeSegments)
    local possibleFoodPositions = {}

    for foodX = 1, self.TILE_X_COUNT do
        for foodY = 1, self.TILE_Y_COUNT do
            local possible = true

            for _, segment in ipairs(snakeSegments) do
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
    self.x = foodPosition.x
    self.y = foodPosition.y
    return foodPosition
end

function Food:draw()
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.rectangle(
        "fill",
        (self.x - 1) * self.TILE_SIZE,
        (self.y - 1) * self.TILE_SIZE,
        self.TILE_SIZE,
        self.TILE_SIZE
    )
end

return Food
