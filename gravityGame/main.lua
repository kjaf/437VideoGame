-- Load some default values for our rectangle.
function love.load()
    Astronaut = {}
    Astronaut.image =  love.graphics.newImage("astronaut.png")
    Astronaut.x = 100
    Astronaut.y = 100 
    angle = 0
    speed = 10
    astronautR = 0


end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
	if love.keyboard.isDown("right") then
      astronautR = astronautR + .004
      text = "rotating"
  end

  	if love.keyboard.isDown("left") then
      astronautR = astronautR + -.004
      text = "rotating"
  end


  -- if love.keyboard.isDown("right") + love.keyboard.isDown("space") then 
  -- 	Astronaut.image = love.graphics.newImage("boosting.png")
  -- end
 -- Astronaut.x = Astronaut.x + (math.cos(math.rad(angle)) * speed * dt)
 -- Astronaut.y = Astronaut.y + (math.cos(math.rad(angle)) * speed * dt)
 textx = Astronaut.x 
 texty = Astronaut.y

	


   
end
 
-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y,astronautR)
    love.graphics.print(textx, 300,300)
    love.graphics.print(texty, 400,400)
end