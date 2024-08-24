--- LayoutManager
--- A class to manage vertical and horizontal layouts in Love2D.
--- @class LayoutManager
--- @field x number
--- @field y number
--- @field spacingX number
--- @field spacingY number
--- @field layoutDirection string
--- @field currentX number
--- @field currentY number
local LayoutManager = {}
LayoutManager.__index = LayoutManager

--- Creates a new LayoutManager instance.
--- This instance can manage either vertical or horizontal layouts.
--- @param x number Starting x position for the layout.
--- @param y number Starting y position for the layout.
--- @param spacingX number Space between elements horizontally.
--- @param spacingY number Space between elements vertically.
--- @param layoutDirection string The direction of the layout, either `vertical` or `horizontal`.
--- @return table self A new instance of LayoutManager.
function LayoutManager:new(x, y, spacingX, spacingY, layoutDirection)
    local instance = setmetatable({}, LayoutManager)
    instance.x = x
    instance.y = y
    instance.spacingX = spacingX
    instance.spacingY = spacingY
    instance.layoutDirection = layoutDirection
    instance.currentX = instance.x
    instance.currentY = instance.y
    return instance
end

--- Adds an element to the layout.
--- The element will be positioned based on the current layout direction.
--- @param element table The element to be added. It must have `x` and `y` properties.
--- @param width number The width of the element. If not provided `element.width` is used.
--- @param height number The height of the element. If not provided `element.height` is used.
--- @param marginX number|nil Optional margin to add the the element's x position. Defaults to `0`.
--- @param marginY number|nil Optional margin to add the the element's y position. Defaults to `0`.
function LayoutManager:addElement(element, width, height, marginX, marginY)
    marginX = marginX or 0
    marginY = marginY or 0

    if self.layoutDirection == "vertical" then
        element.x = self.x + marginX
        element.y = self.currentY + marginY
        self.currentY = self.currentY + (height or element.height) + self.spacingY
    elseif self.layoutDirection == "horizontal" then
        element.x = self.currentX + marginX
        element.y = self.y + marginY
        self.currentX = self.currentX + (width or element.width) + self.spacingX
    end
end

--- Resets the layout manager to its initial position.
-- This is useful when you want to start laying out elements from the beginning again.
function LayoutManager:reset()
    self.currentX = self.x
    self.currentY = self.y
end

--- Returns the current position in the layout.
-- @return (number, number) The current x and y positions.
function LayoutManager:getPosition()
    return self.currentX, self.currentY
end

---@type LayoutManager
return LayoutManager
