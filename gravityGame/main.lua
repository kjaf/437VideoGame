
function love.load()
    Astronaut = {}

    Astronaut.image =  love.graphics.newImage("/images/astronaut.png")
    Astronaut.x = 100
    Astronaut.y = 100 
    angle = 0
    speed = 2
    astronautR = 0
    text = "nothing"
  


    function love.keyreleased(key)
      if key == "space" then
        Astronaut.image = love.graphics.newImage("/images/astronaut.png")
      end
    end






end
 

function love.update(dt)
	if love.keyboard.isDown("right") then
      astronautR = astronautR + .01
  end

  	if love.keyboard.isDown("left") then
      astronautR = astronautR + -.01
  end


  if (love.keyboard.isDown("space")) then 
  	Astronaut.image = love.graphics.newImage("/images/boosting.png")
    Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
    Astronaut.y = Astronaut.y + math.sin(astronautR) * speed 
  end

 


 

 

	


   
end
 

function love.draw()
    love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y,astronautR)
    
    
end