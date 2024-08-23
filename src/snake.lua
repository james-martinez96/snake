local window = require("window")
local LayoutManager = require("ui.LayoutManager")
local Button = require("ui.Button")
local food = require("food")

cellSize, gridXCount, gridYCount = window.setupWindow()

---@type LayoutManager
local layout = LayoutManager:new(50, 50, 10, 20, "vertical")

local buttons = {}

for i = 1, 3 do
    local button = Button:new("Button " .. i, 0, 0, 100, 30)
    table.insert(buttons, button)
    layout:addElement(button, button.w, button.h)
end

local function reset()
    snakeSegments = {
        { x = 3, y = 1 },
        { x = 2, y = 1 },
        { x = 1, y = 1 },
    }
    directionQueue = { "right" }
    snakeAlive = true
    timer = 0
    -- food.moveFood()
    foodPosition = food.moveFood(gridXCount, gridYCount, snakeSegments)
end

function love.load()
    reset()
end

function love.update(dt)
    timer = timer + dt
    for _, button in ipairs(buttons) do
        if button:isClicked() then
            print(button.text .. " clicked!")
        end
    end

    if snakeAlive then
        if timer >= 0.15 then
            timer = 0

            if #directionQueue > 1 then
                table.remove(directionQueue, 1)
            end

            local nextXPosition = snakeSegments[1].x
            local nextYPosition = snakeSegments[1].y

            if directionQueue[1] == "right" then
                nextXPosition = nextXPosition + 1
                if nextXPosition > gridXCount then
                    nextXPosition = 1
                end
            elseif directionQueue[1] == "left" then
                nextXPosition = nextXPosition - 1
                if nextXPosition < 1 then
                    nextXPosition = gridXCount
                end
            elseif directionQueue[1] == "down" then
                nextYPosition = nextYPosition + 1
                if nextYPosition > gridYCount then
                    nextYPosition = 1
                end
            elseif directionQueue[1] == "up" then
                nextYPosition = nextYPosition - 1
                if nextYPosition < 1 then
                    nextYPosition = gridYCount
                end
            end

            local canMove = true

            for segmentIndex, segment in ipairs(snakeSegments) do
                if segmentIndex ~= #snakeSegments and nextXPosition == segment.x and nextYPosition == segment.y then
                    canMove = false
                end
            end

            if canMove then
                table.insert(snakeSegments, 1, {
                    x = nextXPosition,
                    y = nextYPosition,
                })

                if snakeSegments[1].x == foodPosition.x and snakeSegments[1].y == foodPosition.y then
                    -- food.moveFood(gridXCount, gridYCount, snakeSegments)
                    foodPosition = food.moveFood(gridXCount, gridYCount, snakeSegments)
                else
                    table.remove(snakeSegments)
                end
            else
                snakeAlive = false
            end
        end
    elseif timer >= 2 then
        reset()
    end
end

function love.keypressed(key)
    if key == "right" and directionQueue[#directionQueue] ~= "right" and directionQueue[#directionQueue] ~= "left" then
        table.insert(directionQueue, "right")
    elseif
        key == "left"
        and directionQueue[#directionQueue] ~= "left"
        and directionQueue[#directionQueue] ~= "right"
    then
        table.insert(directionQueue, "left")
    elseif key == "up" and directionQueue[#directionQueue] ~= "up" and directionQueue[#directionQueue] ~= "down" then
        table.insert(directionQueue, "up")
    elseif key == "down" and directionQueue[#directionQueue] ~= "down" and directionQueue[#directionQueue] ~= "up" then
        table.insert(directionQueue, "down")
    end
end

function love.draw()
    love.graphics.setColor(0.28, 0.28, 0.28)
    love.graphics.rectangle("fill", 0, 0, gridXCount * cellSize, gridYCount * cellSize)

    local function drawCell(x, y)
        love.graphics.rectangle("fill", (x - 1) * cellSize, (y - 1) * cellSize, cellSize - 1, cellSize - 1)
    end

    for segmentIndex, segment in ipairs(snakeSegments) do
        if snakeAlive then
            love.graphics.setColor(0.6, 1, 0.32)
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
        end
        drawCell(segment.x, segment.y)
    end

    love.graphics.setColor(1, 0.3, 0.3)
    drawCell(foodPosition.x, foodPosition.y)

    for _, button in ipairs(buttons) do
        button:draw()
    end
end
