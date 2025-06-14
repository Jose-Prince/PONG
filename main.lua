function love.load()
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  local width = 40
  local height = 200

  local x1 = 0
  local x2 = love.graphics.getWidth() - width

  local y1 = (love.graphics.getHeight() / 2) - height/2
  local y2 = (love.graphics.getHeight() / 2) - height/2

  Object = require "classic"
  require "player"

  player1 = Player(width, height, x1, y1, "w", "s")
  player2 = Player(width, height, x2, y2, "up", "down")
end

function love.update(dt)
  --Movement player 1
  player1:move(dt)

  --Movement player 2
  player2:move(dt)
end

function love.draw()
  -- Players
  player1:draw()
  player2:draw()

  -- Ball
  love.graphics.circle("fill", 200, 200, 100)
end
