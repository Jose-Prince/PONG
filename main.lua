Object = require "classic"
require "player"
require "ball"
require "scorepoint"
require "msgScreen"

local font_medium
local font_large
local options = { "PLAY", "SETTINGS", "QUIT GAME"}
local selected = 1
local gameStarted = false
local optionStarted = false
local roundEnd = false
local isPaused = false

local settings = { "BACKGROUND", "SCREEN SIZE", "BALL SPEED"}
local selected_settings = 1
local colors = { "BLACK", "BLUE", "GREEN", "ORANGE", "RED" }
local rgb_colors = { {0, 0, 0}, {0, 0, 255}, {0, 255, 0}, {255, 165, 0}, {255, 0, 0} }
local sizes = { "SMALL", "MEDIUM", "BIG", "FULL SCREEN" }
local num_sizes = {{400, 300}, {800, 600}, {1200, 1000}}

local actual_color = 1
local actual_size = 2

local ball
local player1
local player2
local scorepoint
local msgScreen

local screen_width
local screen_height

local lastScorer = 0
local speed
local timer = 0

function love.load()
  love.window.setTitle("PONG GAME")
  local icon = love.image.newImageData("logo/NNugSj.png")
  if icon then
    love.window.setIcon(icon)
  end


  backgroundMusic = love.audio.newSource("music/Undertale-Papyrus-Theme.ogg", "stream")
  backgroundMusic:setLooping(true)
  backgroundMusic:setVolume(0.3)
  backgroundMusic:play()

  collideSound = love.audio.newSource("music/gameboy-pluck-41265.ogg", "static")
  collideSound:setLooping(false)
  collideSound:setVolume(0.5)

  love.window.setMode(num_sizes[actual_size][1], num_sizes[actual_size][2], {resizable=false, vsync=0, minwidth=400, minheight=300})

  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()

  font_medium = love.graphics.newFont("font/Minecraft.ttf", screen_height/18)
  font_large = love.graphics.newFont("font/Minecraft.ttf", screen_height/6)

  local width = screen_height/32
  local height = screen_height/5

  local x1 = 0
  local x2 = love.graphics.getWidth() - width

  local y = (love.graphics.getHeight() / 2) - height/2

  speed = 5 * screen_width / 8

  player1 = Player(width, height, x1, y, "w", "s", 3 * speed / 4)
  player2 = Player(width, height, x2, y, "up", "down", 3 * speed / 4)
  scorepoint = Scorepoint(rgb_colors[actual_color])
  msgScreen = MsgScreen(screen_width/2,screen_height/2, screen_width/2, screen_width/3, rgb_colors[actual_color])
end

function love.update(dt)
  timer = timer + dt
  if not gameStarted or optionStarted then
    return
  end

  if not isPaused then
    --Movement player 1
    player1:move(dt)

    --Movement player 2
    player2:move(dt)

    if not roundEnd then
      ball:move(dt)
    end

  end

  if ball.x > screen_width / 2 then
    if checkCollision(player2, ball) then
      local sfx = collideSound:clone()
      sfx:play()
      ball:bounceOff(player2)
    end
  else
    if checkCollision(player1, ball) then
      local sfx = collideSound:clone()
      sfx:play()
      ball:bounceOff(player1)
    end
  end

  local player_point = ball:checkPoint()
  if player_point ~= 0 then
    scorepoint:update(player_point)
    roundEnd = true
    lastScorer = player_point
    msgScreen.startTime = love.timer.getTime()
  end
end

function love.draw()
  local r,g, b = love.math.colorFromBytes(rgb_colors[actual_color][1], rgb_colors[actual_color][2], rgb_colors[actual_color][3])
  love.graphics.setBackgroundColor(r, g, b)
  if not gameStarted and not optionStarted then
    drawMenu()
    player1.y = (love.graphics.getHeight() / 2) - screen_height/5/2
    player2.y = (love.graphics.getHeight() / 2) -  screen_height/5/2
    scorepoint = Scorepoint(rgb_colors[actual_color])
    roundEnd = false
    ball = Ball(screen_width/2,screen_height/2, screen_height/64, calculateBallDirection(), speed)
  elseif optionStarted then
    drawSettings()
  elseif gameStarted then
    if isPaused then

      -- Scores
      scorepoint:draw()

      msgScreen:draw(lastScorer)
      player1:draw()
      player2:draw()

    else
      -- Players
      player1:draw()
      player2:draw()

      if roundEnd then
        ball.x = screen_width / 2
      else
        -- Ball
        ball:draw()
      end

      -- Scores
      scorepoint:draw()
    end


    if roundEnd then
      roundEnd = msgScreen:draw(lastScorer)
      ball.speed = speed
      ball.y = screen_height/2
      player1.y = (love.graphics.getHeight() / 2) - screen_height/5/2
      player2.y = (love.graphics.getHeight() / 2) -  screen_height/5/2
    end
  end
end

function drawMenu()
  local y = screen_height / 1.7
  love.graphics.setFont(font_large)
  love.graphics.printf("PONG", 0, screen_height/4, love.graphics.getWidth(), "center")

  love.graphics.setFont(font_medium)
  for i, option in ipairs(options) do
    if i == selected then
      love.graphics.setColor(1, 1, 0)
    else
      love.graphics.setColor(1, 1, 1)
    end
    love.graphics.printf(option, 0, y, love.graphics.getWidth(), "center")
    y = y + screen_height / 10
  end

  love.graphics.setColor(1, 1, 1)
end

function drawSettings()
  local y = screen_height / 5
  love.graphics.setFont(font_medium)
  love.graphics.printf("SETTINGS ", 0, screen_height/10, love.graphics.getWidth(), "center")


  for i, option in ipairs(settings) do
    if i == selected_settings then
      love.graphics.setColor(1, 1, 0)
    else
      love.graphics.setColor(1, 1, 1)
    end
    love.graphics.printf(option, 10, y, love.graphics.getWidth(), "left")
    if option == "BACKGROUND" then
      love.graphics.printf(colors[actual_color], -10, y, love.graphics.getWidth(), "right")
    elseif option == "SCREEN SIZE" then
      love.graphics.printf(sizes[actual_size], -10, y, love.graphics.getWidth(), "right")
    else
      love.graphics.printf(speed, -10, y, love.graphics.getWidth(), "right")
    end
    y = y + screen_height / 12
  end

  love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
  if not gameStarted and not optionStarted then
    if key == "up" then
      selected = selected - 1
      if selected < 1 then selected = #options end
    elseif key == "down" then
      selected = selected + 1
      if selected > #options then selected = 1 end
    elseif key == "return" or key == "enter" then
      if options[selected] == "PLAY" then
        gameStarted = true
      elseif options[selected] == "SETTINGS" then
        optionStarted = true
      elseif options[selected] == "QUIT GAME" then
        love.event.quit()
      end
    end
  elseif optionStarted then
    if key == "up" then
      selected_settings = selected_settings - 1
      if selected_settings < 1 then selected_settings = #settings end
    elseif key == "down" then
      selected_settings = selected_settings + 1
      if selected_settings > #settings then selected_settings = 1 end
    elseif key == "escape" then
      optionStarted = false
    elseif selected_settings == 1 then
      if key == "right" then
        actual_color = actual_color + 1
        if actual_color > #colors then actual_color = 1 end
        msgScreen.color = rgb_colors[actual_color]
        scorepoint.color = rgb_colors[actual_color]
      elseif key == "left" then
        actual_color = actual_color - 1
        if actual_color < 1 then actual_color = #colors end
        msgScreen.color = rgb_colors[actual_color]
        scorepoint.color = rgb_colors[actual_color]
      end
    elseif selected_settings == 2 then
      if key == "right" then
        actual_size = actual_size + 1
        if actual_size > #sizes then actual_size = 1 end
        resizeWindow()
      elseif key == "left" then
        actual_size = actual_size - 1
        if actual_size < 1 then actual_size = #sizes end
        resizeWindow()
      end
    elseif selected_settings == 3 then
      if key == "right" then
        speed = speed + 10
      elseif key == "left" then
        speed = speed - 10
      end
    end
  elseif gameStarted then
    if key == "escape" then
      gameStarted = false
    elseif key == "space" then
      isPaused = not isPaused
      -- Pause the game
      if msgScreen.type == "score" then
        msgScreen.type = "pause"
      elseif msgScreen.type == "pause" then
        msgScreen.type = "score"
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

function resizeWindow()
  if sizes[actual_size] == "FULL SCREEN" then
    love.window.setMode(0, 0, {fullscreen=true})
  else
    local w, h = num_sizes[actual_size][1], num_sizes[actual_size][2]
    love.window.setMode(w, h, {fullscreen=false, resizable=false})
  end

  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()

  font_medium = love.graphics.newFont("font/Minecraft.ttf", screen_height/18)
  font_large = love.graphics.newFont("font/Minecraft.ttf", screen_height/6)

  relocateObjects()
end

function relocateObjects()
  local height = screen_height/5
  local width = screen_height/32

  local x1 = 0
  local x2 = love.graphics.getWidth() - width

  local y = (love.graphics.getHeight() / 2) - height/2

  speed = 5 * screen_width / 8

  player1 = Player(width, height, x1, y, "w", "s", 3 * speed / 4)
  player2 = Player(width, height, x2, y, "up", "down", 3 * speed / 4)
  ball = Ball(screen_width/2, screen_height/2, screen_width/64, calculateBallDirection(), speed)
  msgScreen = MsgScreen(screen_width/2,screen_height/2, screen_width/2, screen_width/2, rgb_colors[actual_color])
end

-- Calculate initial direction of ball
function calculateBallDirection()
  local angle = math.random(-20, 20)
    if math.random(0, 1) == 1 then
      angle = angle + 180
    end
  return math.rad(angle)

end
