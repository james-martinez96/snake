local Button = require("ui.Button")
local Food = require("Food")
local LayoutManager = require("ui.LayoutManager")
local Snake = require("snake")
local window = require("window")

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
    ---@type Food
    food = Food:new(TILE_X_COUNT, TILE_Y_COUNT)

    foodPosition = food:move(snake.segments)
    snake:reset()
end

function love.update(dt)
    snake:update(dt)

    for _, button in ipairs(buttons) do
        if button:isClicked() then
            print(button.text .. " clicked!")
        end
    end

    -- eating
    if snake.alive then
        if snake.segments[1].x == foodPosition.x and snake.segments[1].y == foodPosition.y then
            snake:grow()
            foodPosition = food:move(snake.segments)
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

function drawBackground()
    -- Draw Background
    love.graphics.setColor(0.28, 0.28, 0.28)
    love.graphics.rectangle("fill", 0, 0, TILE_X_COUNT * TILE_SIZE, TILE_Y_COUNT * TILE_SIZE)
end

function drawFood()
    -- Draw Food
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.rectangle(
        "fill",
        (foodPosition.x - 1) * TILE_SIZE,
        (foodPosition.y - 1) * TILE_SIZE,
        TILE_SIZE,
        TILE_SIZE
    )
end

function love.draw()
    drawBackground()

    snake:draw()

    drawFood()

    drawGrid()

    for _, button in ipairs(buttons) do
        button:draw()
    end
end
