local Button = require("ui.Button")
local LayoutManager = require("ui.LayoutManager")
local food = require("food")
local window = require("window")
local Snake = require("player")

TILE_SIZE, TILE_X_COUNT, TILE_Y_COUNT = window.setupWindow()
---@type LayoutManager
local layout = LayoutManager:new(50, 50, 0, 20, "vertical")

local buttons = {}

for i = 1, 3 do
    local button = Button:new("Button " .. i, 0, 0, 100, 30)
    table.insert(buttons, button)
    layout:addElement(button, button.w, button.h)
end

local snake = Snake:new({
    { x = 3, y = 1 },
    { x = 2, y = 1 },
    { x = 1, y = 1 },
}, TILE_SIZE, TILE_X_COUNT, TILE_Y_COUNT)

function love.load()
    snake:reset()
    foodPosition = food.moveFood(TILE_X_COUNT, TILE_Y_COUNT, snake.segments)
end

function love.update(dt)
    snake:update(dt)

    for _, button in ipairs(buttons) do
        if button:isClicked() then
            print(button.text .. " clicked!")
        end
    end

    if snake.alive then
        if snake.segments[1].x == foodPosition.x and snake.segments[1].y == foodPosition.y then
            snake:grow()
            foodPosition = food.moveFood(TILE_X_COUNT, TILE_Y_COUNT, snake.segments)
        end
    elseif snake.timer >= 2 then
        snake:reset()
    end
end

function love.keypressed(key)
    if key == "right" then
        snake:changeDirection("right")
    elseif key == "left" then
        snake:changeDirection("left")
    elseif key == "up" then
        snake:changeDirection("up")
    elseif key == "down" then
        snake:changeDirection("down")
    end
end

function drawGrid()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(3)

    -- Horizontal lines
    for i = 0, TILE_Y_COUNT do
        love.graphics.line(0, i * TILE_SIZE, TILE_X_COUNT * TILE_SIZE, i * TILE_SIZE)
    end

    -- Vertical lines
    for i = 0, TILE_X_COUNT do
        love.graphics.line(i * TILE_SIZE, 0, i * TILE_SIZE, TILE_Y_COUNT * TILE_SIZE)
    end
end

function love.draw()
    -- Draw Background
    love.graphics.setColor(0.28, 0.28, 0.28)
    love.graphics.rectangle("fill", 0, 0, TILE_X_COUNT * TILE_SIZE, TILE_Y_COUNT * TILE_SIZE)

    if snake.alive then
        love.graphics.setColor(0.6, 1, 0.32)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end

    -- Draw Snake
    snake:draw()

    -- Draw Food
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.rectangle("fill", (foodPosition.x - 1) * TILE_SIZE, (foodPosition.y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)

    -- drawGrid()

    for _, button in ipairs(buttons) do
        button:draw()
    end
end
