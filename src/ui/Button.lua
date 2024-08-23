local Button = {}
Button.__index = Button

function Button:new(text, x, y, w, h)
    local self = setmetatable({}, Button)
    self.text = text
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    return self
end

function Button:isHovered()
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX > self.x and mouseX < self.x + self.w and mouseY > self.y and mouseY < self.y + self.h
end

function Button:isClicked()
    return self:isHovered() and love.mouse.isDown(1)
end

function Button:draw()
    local color = {0.5, 0.5, 0.5}
    if self:isHovered() then color = {0.7, 0.7, 0.7} end
    if self:isClicked() then color = {0.9, 0.9, 0.9} end
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.text, self.x, self.y + self.h/2 - 6, self.w, "center")
end

return Button

-- Usage in love.draw
-- local button = Button:new("Click me!", 100, 100, 200, 50)
-- button:draw()
--
-- if button:isClicked() then
--     print("Button clicked!")
-- end
