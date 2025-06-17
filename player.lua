Player = Object.extend(Object)

function Player:new(width, height, x, y, up, down, speed)
  self.width = width
  self.height = height
  self.x = x
  self.y = y
  self.up = up
  self.down = down
  self.speed = speed or 75
end

function Player:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Player:move(dt)
  if love.keyboard.isDown(self.up) and self.y > 0 then
    self.y = self.y - self.speed * dt
  elseif love.keyboard.isDown(self.down) and self.y < love.graphics.getHeight() - self.height then
    self.y = self.y + self.speed * dt
  end
end

function Player:relocate(newX, newY)
  self.x = newX
  self.y = newY
end
