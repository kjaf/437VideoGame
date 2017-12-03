
function love.load()
    Astronaut = {}
    Planets = {}


    for i = 1, 3 do
      Planets[i] = {}
    end




      Planets[1].image = love.graphics.newImage("/images/planets/planet1.png")
      Planets[1].x = 800
      Planets[1].y = 800
      Planets[1].mass = 1000 





    Astronaut.image =  love.graphics.newImage("/images/player/astronaut.png")
    Astronaut.x = 100
    Astronaut.y = 100
    Astronaut.mass = 1  
    


    angle = 0
    speed = 2
    astronautR = 0
    text = "nothing"


    planet = {}

  


    function love.keyreleased(key)
      if key == "space" then
        Astronaut.image = love.graphics.newImage("/images/player/astronaut.png")
      end
    end


    love.window.setMode(1500,1000)




end
 

function love.update(dt)
	if love.keyboard.isDown("right") then
      astronautR = astronautR + .03
  end

  	if love.keyboard.isDown("left") then
      astronautR = astronautR + -.03
  end


  if (love.keyboard.isDown("space")) then 
  	Astronaut.image = love.graphics.newImage("/images/player/boosting.png")
    Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
    Astronaut.y = Astronaut.y + math.sin(astronautR) * speed 
  end

 


 

 

	


   
end
 

function love.draw()
    love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y,astronautR,.75,.75)
    love.graphics.draw(Planets[1].image, Planets[1].x, Planets[1].y,0,3,3)
    
    
end