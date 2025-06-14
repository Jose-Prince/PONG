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

function Ball:move(dt)
  self.y = self.y + (100 * math.sin(self.direction)) * dt
  self.x = self.x + (100 * math.cos(self.direction)) * dt
  self:redirection()
end

function Ball:redirection()
  local top = 0
  local bottom = love.graphics.getHeight()

  if self.y - self.radius < top then
    self.y = top + self.radius
    self.direction = -self.direction
  end

  if self.y + self.radius > bottom then
    self.y = bottom - self.radius
    self.direction = -self.direction
  end
end

function Ball:bounceOff(player)
  local player_center = player.y + player.height / 2
  local offset = (self.y - player_center) / (player.height / 2)

  local MAX_BOUNCE_ANGLE = math.rad(60)
  local bounce_angle = offset * MAX_BOUNCE_ANGLE

  local going_right = self.x < love.graphics.getWidth() / 2
  local direction = going_right and 1 or -1

  self.direction = direction * math.pi / 2 + bounce_angle
end
