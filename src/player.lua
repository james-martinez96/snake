local Snake = {}
Snake.__index = Snake

function Snake:new(startingSegments, tileSize, tileXCount, tileYCount)
    local instance = setmetatable({}, Snake)
    instance.segments = startingSegments
    instance.directionQueue = { "right" }
    instance.alive = true
    instance.tileSize = tileSize
    instance.tileXCount = tileXCount
    instance.tileYCount = tileYCount
    instance.timer = 0
    return instance
end

function Snake:reset()
    self.segments = {
        { x = 3, y = 1 },
        { x = 2, y = 1 },
        { x = 1, y = 1 },
    }
    self.directionQueue = { "right" }
    self.alive = true
    self.timer = 0
end

function Snake:update(dt)
    self.timer = self.timer + dt
    if self.alive then
        if self.timer >= 0.1 then
            self.timer = 0

            if #self.directionQueue > 1 then
                table.remove(self.directionQueue, 1)
            end

            local nextXPosition = self.segments[1].x
            local nextYPosition = self.segments[1].y

            if self.directionQueue[1] == "right" then
                nextXPosition = nextXPosition + 1
                if nextXPosition > self.tileXCount then
                    nextXPosition = 1
                end
            elseif self.directionQueue[1] == "left" then
                nextXPosition = nextXPosition - 1
                if nextXPosition < 1 then
                    nextXPosition = self.tileXCount
                end
            elseif self.directionQueue[1] == "down" then
                nextYPosition = nextYPosition + 1
                if nextYPosition > self.tileYCount then
                    nextYPosition = 1
                end
            elseif self.directionQueue[1] == "up" then
                nextYPosition = nextYPosition - 1
                if nextYPosition < 1 then
                    nextYPosition = self.tileYCount
                end
            end

            local canMove = true
            for segmentIndex, segment in ipairs(self.segments) do
                if segmentIndex ~= #self.segments and nextXPosition == segment.x and nextYPosition == segment.y then
                    canMove = false
                end
            end

            if canMove then
                table.insert(self.segments, 1, { x = nextXPosition, y = nextYPosition })
                if not (self.segments[1].x == foodPosition.x and self.segments[1].y == foodPosition.y) then
                    table.remove(self.segments)
                end
            else
                self.alive = false
            end
        end
    end
end

function Snake:grow()
    -- Leave the last segment in place when growing
    table.insert(self.segments, {
        x = self.segments[#self.segments].x,
        y = self.segments[#self.segments].y,
    })
end

function Snake:draw()
    for _, segment in ipairs(self.segments) do
        love.graphics.rectangle(
            "fill",
            (segment.x - 1) * self.tileSize,
            (segment.y - 1) * self.tileSize,
            self.tileSize,
            self.tileSize
        )
    end
end

function Snake:changeDirection(newDirection)
    local lastDirection = self.directionQueue[#self.directionQueue]
    if
        not (
            (lastDirection == "left" and newDirection == "right")
            or (lastDirection == "right" and newDirection == "left")
            or (lastDirection == "up" and newDirection == "down")
            or (lastDirection == "down" and newDirection == "up")
        )
    then
        table.insert(self.directionQueue, newDirection)
    end
end

return Snake
