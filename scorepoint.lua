Scorepoint = Object.extend(Object)

local font = love.graphics.newFont("font/Minecraft.ttf", love.graphics.getWidth() / 8)

function Scorepoint:new()
  self.player1_score = 0
  self.player2_score = 0
end

function Scorepoint:draw()
  local width = love.graphics.getWidth()
  love.graphics.setFont(font)
  love.graphics.printf(self.player1_score, width / 4, 50, width, "left")
  love.graphics.printf(self.player2_score, -width / 4, 50, width, "right")

  local y = 0
  local total_lines = love.graphics.getHeight() / ((width / 16) * 1.2)
  for i = 1, math.ceil(total_lines), 1 do
    love.graphics.rectangle("fill", width / 2 - (width / 64), y, width / 32, width / 16)
    y = y + (width / 16) * 1.2
  end
end

function Scorepoint:update(player)
  if player == 1 then
    self.player1_score = self.player1_score + 1
  elseif player == 2 then
    self.player2_score = self.player2_score + 1
  end
end
