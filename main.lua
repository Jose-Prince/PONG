local options = { "PLAY", "OPTIONS", "QUIT GAME"}
local selected = 1
local gameStarted = false

function love.load()

  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  local width = 40
  local height = 200

  local x1 = 0
  local x2 = love.graphics.getWidth() - width

  local y1 = (love.graphics.getHeight() / 2) - height/2
  local y2 = (love.graphics.getHeight() / 2) - height/2

  local angle = math.random(-45, 45)
  if math.random(0, 1) == 1 then
    angle = angle + 180
  end
  local radians = math.rad(angle)

  Object = require "classic"
  require "player"
  require "ball"

  player1 = Player(width, height, x1, y1, "w", "s")
  player2 = Player(width, height, x2, y2, "up", "down")
  ball = Ball(screen_width/2,screen_height/2,50, radians)
end

function love.update(dt)

  --Movement player 1
  player1:move(dt)

  --Movement player 2
  player2:move(dt)

  ball:move(dt)

  if ball.x > screen_width / 2 then 
    if checkCollision(player2, ball) then
      ball:bounceOff(player2)
    end
  else
    if checkCollision(player1, ball) then
      ball:bounceOff(player1)
    end
  end
end

function love.draw()
  if not gameStarted then
    drawMenu()
  else
    -- Players
    player1:draw()
    player2:draw()

    -- Ball
    ball:draw()
  end
end

function drawMenu()
  love.graphics.setFont(love.graphics.newFont(100))
  love.graphics.printf("PONG", 0, 150, love.graphics.getWidth(), "center")
  
  love.graphics.setFont(love.graphics.newFont(32))
  for i, option in ipairs(options) do
    local y = 300 + (i - 1) * 60
    if i == selected then
      love.graphics.setColor(1, 1, 0)
    else
      love.graphics.setColor(1, 1, 1)
    end
    love.graphics.printf(option, 0, y, love.graphics.getWidth(), "center")
  end

  love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
  if not gameStarted then
    if key == "up" then
      selected = selected - 1
      if selected < 1 then selected = #options end
    elseif key == "down" then
      selected = selected + 1
      if selected > #options then selected = 1 end
    elseif key == "return" or key == "enter" then
      if options[selected] == "PLAY" then
        gameStarted = true
      elseif options[selected] == "QUIT GAME" then
        love.event.quit()
      end
    end
  end
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
