local Button = require("ui.Button")
local Food = require("Food")
local LayoutManager = require("ui.LayoutManager")
local Snake = require("snake")
local window = require("window")

local TILE_SIZE, TILE_X_COUNT, TILE_Y_COUNT
local snake
local layout
local buttons

function love.load()
    TILE_SIZE, TILE_X_COUNT, TILE_Y_COUNT = window.setupWindow()

    ---@type LayoutManager
    layout = LayoutManager:new(50, 50, 0, 20, "vertical")

    buttons = {}

    for i = 1, 3 do
        local button = Button:new("Button " .. i, 0, 0, 100, 30)
        table.insert(buttons, button)
        layout:addElement(button, button.w, button.h)
    end

    -- TODO: handle snake segments in snake.lua
    snake = Snake:new({
        { x = 3, y = 1 },
        { x = 2, y = 1 },
        { x = 1, y = 1 },
    }, TILE_SIZE, TILE_X_COUNT, TILE_Y_COUNT)

    ---@type Food
    food = Food:new(TILE_X_COUNT, TILE_Y_COUNT, TILE_SIZE)

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
    -- Draw a square 1 pixel smaller then the grid to simulate grid lines.
    love.graphics.setColor(0.28, 0.28, 0.28)
    for x = 1, TILE_X_COUNT do
        for y = 1, TILE_Y_COUNT do
            love.graphics.rectangle("fill", (x-1) * TILE_SIZE, (y-1) * TILE_SIZE, TILE_SIZE - 1, TILE_SIZE - 1)
        end
    end

    -- love.graphics.setColor(0, 0, 0)
    -- love.graphics.setLineWidth(3)
    --
    -- -- Horizontal lines
    -- for i = 0, TILE_Y_COUNT do
    --     love.graphics.line(0, i * TILE_SIZE, TILE_X_COUNT * TILE_SIZE, i * TILE_SIZE)
    -- end
    --
    -- -- Vertical lines
    -- for i = 0, TILE_X_COUNT do
    --     love.graphics.line(i * TILE_SIZE, 0, i * TILE_SIZE, TILE_Y_COUNT * TILE_SIZE)
    -- end
end

-- function drawBackground()
--     -- Draw Background
--     love.graphics.setColor(0.28, 0.28, 0.28)
--     love.graphics.rectangle("fill", 0, 0, TILE_X_COUNT * TILE_SIZE, TILE_Y_COUNT * TILE_SIZE)
-- end

function love.draw()
    -- drawBackground()
    drawGrid()

    snake:draw()

    food:draw()

    for _, button in ipairs(buttons) do
        button:draw()
    end
end
