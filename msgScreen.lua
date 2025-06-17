MsgScreen = Object.extend(Object)

local font

function MsgScreen:new(x, y, width, height, color)
  self.x = x
  self.y = y
  self.width = width
  self.startTime = love.timer.getTime()
  self.height = height
  self.color = color
  self.type = "score"

  font = love.graphics.newFont("font/Minecraft.ttf", love.graphics.getWidth() / 32)
end

function MsgScreen:draw(player)
  love.graphics.setFont(font)
  local winner
  if player == 1 then
    winner = "PLAYER 1"
  else
    winner = "PLAYER 2"
  end

  local r,g, b = love.math.colorFromBytes(self.color[1], self.color[2], self.color[3])
  love.graphics.setColor(r, g, b)
  love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
  love.graphics.setColor(1, 1, 1)

  if self.type == "score" then

    love.graphics.printf(winner .. " SCORES!", 0, self.y - self.height / 8, love.graphics.getWidth(), "center")
    local elapsed = love.timer.getTime() - self.startTime
    if elapsed > 0 and elapsed <= 3 then
      local time = math.floor(elapsed + 0.5)
      love.graphics.printf("NEXT ROUND IN " .. time, 0, self.y + self.height / 8, love.graphics.getWidth(), "center")
    else
      love.graphics.printf("ROUND IS STARTING", 0, self.y + self.height / 8, love.graphics.getWidth(), "center")
      return false
    end
  else
    love.graphics.printf("GAME PAUSED", 0, self.y - self.height / 8, love.graphics.getWidth(), "center")

    return true
  end

  return true
end
