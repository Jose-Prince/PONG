local font_medium
local font_large
local options = { "PLAY", "SETTINGS", "QUIT GAME"}
local selected = 1
local gameStarted = false
local optionStarted = false

local settings = { "BACKGROUND", "SCREEN SIZE"}
local selected_settings = 1
local colors = { "BLACK", "BLUE", "GREEN", "ORANGE", "RED" }
local rgb_colors = { {0, 0, 0}, {0, 0, 255}, {0, 255, 0}, {255, 165, 0}, {255, 0, 0} }
local sizes = { "SMALL", "MEDIUM", "BIG", "FULL SCREEN" }
local num_sizes = {{400, 300}, {800, 600}, {1200, 1000}}

local actual_color = 1
local actual_size = 2

function love.load()
  font_medium = love.graphics.newFont("font/Minecraft.ttf", 32)
  font_large = love.graphics.newFont("font/Minecraft.ttf", 100)
  love.window.setMode(num_sizes[actual_size][1], num_sizes[actual_size][2], {resizable=false, vsync=0, minwidth=400, minheight=300})

  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  local width = 40
  local height = 200

  local x1 = 0
  local x2 = love.graphics.getWidth() - width

  local y = (love.graphics.getHeight() / 2) - height/2

  local angle = math.random(-45, 45)
  if math.random(0, 1) == 1 then
    angle = angle + 180
  end
  local radians = math.rad(angle)

  Object = require "classic"
  require "player"
  require "ball"

  player1 = Player(width, height, x1, y, "w", "s")
  player2 = Player(width, height, x2, y, "up", "down")
  ball = Ball(screen_width/2,screen_height/2,50, radians)
end

function love.update(dt)
  if not gameStarted or optionStarted then
    return
  end

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

  ball:checkPoint()
end

function love.draw()
  local r,g, b = love.math.colorFromBytes(rgb_colors[actual_color][1], rgb_colors[actual_color][2], rgb_colors[actual_color][3])
  love.graphics.setBackgroundColor(r, g, b)
  if not gameStarted and not optionStarted then
    drawMenu()
  elseif optionStarted then
    drawSettings()
  elseif gameStarted then
    -- Players
    player1:draw()
    player2:draw()

    -- Ball
    ball:draw()
  end
end

function drawMenu()
  love.graphics.setFont(font_large)
  love.graphics.printf("PONG", 0, 150, love.graphics.getWidth(), "center")

  love.graphics.setFont(font_medium)
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

function drawSettings()
  love.graphics.setFont(love.graphics.newFont(32))
  love.graphics.printf("SETTINGS ", 0, 50, love.graphics.getWidth(), "center")

  for i, option in ipairs(settings) do
    local y = 100 + (i - 1) * 60
    if i == selected_settings then
      love.graphics.setColor(1, 1, 0)
    else
      love.graphics.setColor(1, 1, 1)
    end
    love.graphics.printf(option, 10, y, love.graphics.getWidth(), "left")
    if option == "BACKGROUND" then
      love.graphics.printf(colors[actual_color], -10, y, love.graphics.getWidth(), "right")
    else
      love.graphics.printf(sizes[actual_size], -10, y, love.graphics.getWidth(), "right")
    end
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
    elseif key == "return" or key == "enter" then
      print("Seleccionaste: ", actual_color)
      -- Aquí podrías implementar comportamiento real para cada configuración
    elseif selected_settings == 1 then
      if key == "right" then
        actual_color = actual_color + 1
        if actual_color > #colors then actual_color = 1 end
      elseif key == "left" then
        actual_color = actual_color - 1
        if actual_color < 1 then actual_color = #colors end
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

  relocateObjects()
end

function relocateObjects()
  local height = 200
  local width = 40

  player1:relocate(0, (love.graphics.getHeight() / 2) - height/2)
  player2:relocate(love.graphics.getWidth() - width, (love.graphics.getHeight() / 2) - height/2)
  ball:relocate(screen_width/2,screen_height/2)
end
