function love.load()
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  local width = 40
  local height = 200

  local x1 = 0
  local x2 = love.graphics.getWidth() - width

  local y1 = (love.graphics.getHeight() / 2) - height/2
  local y2 = (love.graphics.getHeight() / 2) - height/2

  local angle = math.random(0, 365)

  Object = require "classic"
  require "player"
  require "ball"

  player1 = Player(width, height, x1, y1, "w", "s")
  player2 = Player(width, height, x2, y2, "up", "down")
  ball = Ball(screen_width/2,screen_height/2,50, angle)
end

function love.update(dt)
  local hasCollision = false

  --Movement player 1
  player1:move(dt)

  --Movement player 2
  player2:move(dt)

  if ball.x > screen_width / 2 then 
    hasCollision = checkCollision(player2, ball)
  else
    hasCollision = checkCollision(player1, ball)
  end
  ball:move(dt, hasCollision)
end

function love.draw()
  -- Players
  player1:draw()
  player2:draw()

  -- Ball
  ball:draw()
end

function checkCollision(player, ball)
  local player_left = player.x
  local player_right = player.x + player.width
  local player_top = player.y
  local player_bottom = player.y + player.height

  local ball_left = ball.x - ball.radius
  local ball_right = ball.x + ball.radius
  local ball_top = ball.y - ball.radius
  local ball_bottom = ball.y + ball.radius

  return player_right > ball_left
    and player_left < ball_right
    and player_bottom > ball_top
    and player_top < ball_bottom
end
