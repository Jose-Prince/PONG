Player = Object.extend(Object)

function Player:new(width, height, x, y, up, down)
  self.width = width
  self.height = height
  self.x = x
  self.y = y
  self.up = up
  self.down = down
end

function Player:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Player:move(dt)
  if love.keyboard.isDown(self.up) and self.y > 0 then
    self.y = self.y - 100 * dt
  elseif love.keyboard.isDown(self.down) and self.y < screen_height - self.height then
    self.y = self.y + 100 * dt
  end
end
