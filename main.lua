function love.load()
  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()
  width = 40
  height = 200

  x1 = 0
  x2 = love.graphics.getWidth() - width

  y1 = (love.graphics.getHeight() / 2) - height/2
  y2 = (love.graphics.getHeight() / 2) - height/2
end

function love.update(dt)
  --Movement player 1
  if love.keyboard.isDown("w") and y1 > 0 then
    y1 = y1 - 100 * dt
  elseif love.keyboard.isDown("s") and y1 < screen_height - height then
    y1 = y1 + 100 * dt
  end

  --Movement player 2
  if love.keyboard.isDown("up") and y2 > 0 then
    y2 = y2 - 100 * dt
  elseif love.keyboard.isDown("down") and y2 < screen_height - height then
    y2 = y2 + 100 * dt
  end
end

function love.draw()
  love.graphics.rectangle("line", x1, y1, width, height)
  love.graphics.rectangle("fill", x2, y2, width, height)
end
