
function love.load()
    Astronaut = {}
	Asteroids = {}
    Planets = {}
    force = 0 

	angle = 0
    speed = 2
    astronautR = 0
    text = "nothing"
    text1 = "nothing"


    function love.keyreleased(key)
      if key == "space" then
        Astronaut.image = love.graphics.newImage("/images/player/astronaut.png")
      end
    end


    love.window.setMode(800,600)
	
		function createAstronaut()
	    Astronaut = {}
		Astronaut.image =  love.graphics.newImage("/images/player/astronaut.png")
		Astronaut.x = 100
		Astronaut.y = 100
		Astronaut.mass = 1
		Astronaut.dx = 0
		Astronaut.dy = 0 
		Astronaut.speed = 0 
		return Astronaut
	end
	

	function createPlanets(numPlanets)
		for i = 1, numPlanets do
			Planets[i] = {}
			Planets[i].x = love.math.random(100, love.graphics.getWidth() - 100)
			Planets[i].y = love.math.random(100, love.graphics.getHeight() - 100)
			Planets[i].mass = 2000
			Planets[i].image = love.graphics.newImage("/images/planets/planet" .. love.math.random(1, 3) .. ".png")
		end
		
		return Planets
    end
	
	function createAsteroids(planets, maximum)
		for i in pairs(planets) do
			for j = 1, love.math.random(1, maximum) do
				Asteroids[j] = {}
				Asteroids[j].x = Planets[i].x + love.math.random(-100, 100)
				Asteroids[j].y = Planets[i].y + love.math.random(60, 100)
				Asteroids[j].mass = 1000
				Asteroids[j].image = love.graphics.newImage("/images/planets/asteroid" .. love.math.random(1, 3) .. ".png")
			end
		end
		return Asteroids
	end
	
	Astronaut = createAstronaut()
	Planets = createPlanets(2)
	createAsteroids(Planets, 2)


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
    love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y,astronautR,.6,.6)
	
	for i in pairs(Asteroids) do
		love.graphics.draw(Asteroids[i].image, Asteroids[i].x, Asteroids[i].y,0,.75,.75)
	end
		
	for j in pairs(Planets) do
		love.graphics.draw(Planets[j].image, Planets[j].x, Planets[j].y,0,2.5,2.5)
	end
	
    love.graphics.print(text, 300,300)
    
    
end