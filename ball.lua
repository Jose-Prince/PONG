Ball = Object.extend(Object)

function Ball:new(x, y, radius, direction)
  self.x = x
  self.y = y
  self.radius = radius
  self.direction = direction
end

function Ball:draw()
  love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Ball:move(dt, collide)
  self.y = self.y + (100 * math.sin(self.direction)) * dt
  self.x = self.x + (100 * math.cos(self.direction)) * dt
  self:redirection(collide)
end

function Ball:redirection(collide)
  local total_height = love.graphics.getHeight()
  if collide then
    self.direction = -self.direction
  elseif self.y - self.radius < 0 or self.y + self.radius > total_height + self.radius then
    self.direction = -self.direction
  end
end
