Ball = Object.extend(Object)

function Ball:new(x, y, radius, direction, speed)
  self.x = x
  self.y = y
  self.radius = radius
  self.direction = direction
  self.speed = speed or 100
  self.inc = speed * 0.05
end

function Ball:draw()
  love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Ball:move(dt)
  self.y = self.y + (self.speed * math.sin(self.direction)) * dt
  self.x = self.x + (self.speed * math.cos(self.direction)) * dt
  self:redirection()
end

function Ball:redirection()
  local top = 0
  local bottom = love.graphics.getHeight()

  if self.y - self.radius < top then
    self.y = top + self.radius
    self.direction = -self.direction
    local sfx = collideSound:clone()
    sfx:play()
  end

  if self.y + self.radius > bottom then
    self.y = bottom - self.radius
    self.direction = -self.direction
    local sfx = collideSound:clone()
    sfx:play()
  end
end

function Ball:bounceOff(player)
  local player_center = player.y + player.height / 2
  local offset = (self.y - player_center) / (player.height / 2)
  offset = math.max(-1, math.min(1, offset))

  local MAX_BOUNCE_ANGLE = math.rad(60)
  local bounce_angle = offset * MAX_BOUNCE_ANGLE

  local going_right = math.cos(self.direction) > 0

  if going_right then
    self.direction = math.pi - bounce_angle
    self.x = player.x - self.radius
    self.speed = self.speed + 10
  else
    self.direction = bounce_angle
    self.x = player.x + player.width + self.radius
    self.speed = self.speed + self.inc
  end
end

function Ball:checkPoint()
  if self.x < 0 then
    return 2
  elseif self.x > love.graphics.getWidth() then
    return 1
  else
    return 0
  end
end
