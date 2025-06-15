Scorepoint = Object.extend(Object)

local font = love.graphics.newFont("font/Minecraft.ttf", love.graphics.getWidth() / 8)

function Scorepoint:new()
  self.player1_score = 0
  self.player2_score = 0
end

function Scorepoint:draw()
  love.graphics.setFont(font)
  love.graphics.printf(self.player1_score, love.graphics.getWidth() / 4, 50, love.graphics.getWidth(), "left")
  love.graphics.printf(self.player2_score, -love.graphics.getWidth() / 4, 50, love.graphics.getWidth(), "right")

  local y = 0
  for i = 1, 10, 1 do
    love.graphics.rectangle("fill", love.graphics.getWidth()/2 - 20, y, 40, 80)
    y = y + 90
  end

end
