-- Load some default values for our rectangle.
function love.load()
    Astronaut = {}
    Astronaut.image =  love.graphics.newImage("astronaut.png")
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
   
end
 
-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(Astronaut.image, 100, 100)
end