-- Load some default values for our rectangle.
function love.load()
    Astronaut = {}
    Astronaut.image =  love.graphics.newImage("astronaut.png")
    Astronaut.x = 100
    Astronaut.y = 100
    text = "nothing"

end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
	if love.keyboard.isDown("space") then
      Astronaut.image = love.graphics.newImage("boosting.png")
   end
   
end
 
-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y)
    love.graphics.print(text, 300,300)
end