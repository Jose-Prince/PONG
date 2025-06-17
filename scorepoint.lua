Scorepoint = Object.extend(Object)

local font

function Scorepoint:new()
  self.player1_score = 0
  self.player2_score = 0

  font = love.graphics.newFont("font/Minecraft.ttf", love.graphics.getWidth() / 8)
end

function Scorepoint:draw()
  local width = love.graphics.getWidth()
  love.graphics.setFont(font)
  love.graphics.printf(self.player1_score, width / 4, 50, width, "left")
  love.graphics.printf(self.player2_score, -width / 4, 50, width, "right")

  local y = 0
  local screen_height = love.graphics.getHeight()
  local square_side = screen_height/64
  local total_lines = screen_height / square_side
  for i = 1, math.ceil(total_lines), 1 do
    if i % 2 == 0 then love.graphics.setColor(0,0,0) else love.graphics.setColor(1,1,1) end
    love.graphics.rectangle("fill", width / 2 - (square_side / 2), y, square_side, square_side)
    y = y + (square_side)
  end

  love.graphics.setColor(1,1,1)
end

function Scorepoint:update(player)
  if player == 1 then
    self.player1_score = self.player1_score + 1
  elseif player == 2 then
    self.player2_score = self.player2_score + 1
  end
end
