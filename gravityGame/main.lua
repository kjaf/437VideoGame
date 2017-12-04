
function love.load()
    Astronaut = {}
    Planets = {}
    force = 0 


    for i = 1, 3 do
      Planets[i] = {}
    end

    




      Planets[1].image = love.graphics.newImage("/images/planets/planet1.png")
      Planets[1].x = 400
      Planets[1].y = 400
      Planets[1].mass = 2000 





    Astronaut.image =  love.graphics.newImage("/images/player/astronaut.png")
    Astronaut.x = 100
    Astronaut.y = 100
    Astronaut.mass = 1
    Astronaut.dx = 0
    Astronaut.dy = 0 
    Astronaut.speed = 0 
    


    angle = 0
    speed = 2
    astronautR = 0
    text = "nothing"
    text1 = "nothing"


    planet = {}

  


    function love.keyreleased(key)
      if key == "space" then
        Astronaut.image = love.graphics.newImage("/images/player/astronaut.png")
      end
    end


    love.window.setMode(800,600)


    function checkGravity(planetMass)
      local dist = checkDistance()
      --local dir = angleTo(Planets[1])
      local force = ((planetMass * Astronaut.mass) / (dist * dist))
      return force
      -- Astronaut.x = Astronaut.x + math.cos(astronautR) * force
      -- Astronaut.y = Astronaut.y + math.sin(astronautR) * force

    end


    function angleTo(Planets)




      local diffx = Planets.x - Astronaut.x
      local diffy =  Planets.y - Astronaut.y

        
      local radians = math.atan2(diffy,diffx)
      -- text = radians
      return radians
    end
    


    function checkDistance()
      local dx = Astronaut.x - Planets[1].x
      local dy = Astronaut.y - Planets[1].y
      local distance =  math.sqrt(dx * dx + dy * dy)
       -- local angle = angleTo(Planets[1])
      return distance
    end


    function addVector(thrust, radian)
      -- text = radian
      -- Astronaut.x = Astronaut.x + math.cos(radian) * .5
      -- Astronaut.y = Astronaut.y + math.sin(radian) * .5


      local newDX = math.cos(radian)
      local newDY = math.sin(radian)
      text1 = radian
      text = newDY
      Astronaut.x = Astronaut.x + math.cos(radian) * thrust
      Astronaut.y = Astronaut.y + math.sin(radian) * thrust
    end 

    function calcSpeedAngle()
      Astronaut.speed = math.sqrt((Astronaut.dx*Astronaut.dx) +(Astronaut.dy*Astronaut.dy))
      text = Astronaut.speed
    end








    




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

  force = checkGravity(Planets[1].mass)
  angle = angleTo(Planets[1])

  addVector(force, angle)



 


 

 

	


   
end
 

function love.draw()
    love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y,astronautR,.75,.75)
    love.graphics.draw(Planets[1].image, Planets[1].x, Planets[1].y,0,5,5)
    love.graphics.print(text, 300,300)
    love.graphics.print(text1, 310,310)
    
    
end