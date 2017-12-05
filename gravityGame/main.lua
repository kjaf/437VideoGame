
function love.load()
    Astronaut = {}
	  Asteroids = {}
    Planets = {}
    Fuel = {}
    score = 60
    force = 0 

	  angle = 0
    speed = 2
    astronautR = 0
    text = "nothing"
    text1 = "nothing"

    --can change starting fuel amount here
    Fuel.image =  love.graphics.newImage("/images/HUD/fuel100.png")
    Fuel.x = 50
    Fuel.y = 500
    Fuel.amount = 20


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
  --score goes down every update (every second)
  score = score - dt
  intScore = math.ceil(score)
  --if score is <= 0, stay at 0
  if intScore <= 0 then
     intScore = 0
  end

	if love.keyboard.isDown("right") then
      astronautR = astronautR + .03
  end

  	if love.keyboard.isDown("left") then
      astronautR = astronautR + -.03
  end

  if (love.keyboard.isDown("space")) then 
    Fuel.amount = Fuel.amount - dt
    Astronaut.image = love.graphics.newImage("/images/player/boosting.png")  
    if Fuel.amount <= 100 and Fuel.amount > 90 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel100.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed     
    elseif Fuel.amount <= 90 and Fuel.amount > 80 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel90.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed    
    elseif Fuel.amount <= 80 and Fuel.amount > 70 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel80.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed    
    elseif Fuel.amount <= 70 and Fuel.amount > 60 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel70.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed    
    elseif Fuel.amount <= 60 and Fuel.amount > 50 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel60.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed       
    elseif Fuel.amount <= 50 and Fuel.amount > 40 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel50.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed       
    elseif Fuel.amount <= 40 and Fuel.amount > 30 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel40.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed       
    elseif Fuel.amount <= 30 and Fuel.amount > 20 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel30.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed     
    elseif Fuel.amount <= 20 and Fuel.amount > 10 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel20.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed    
    elseif Fuel.amount <= 10 and Fuel.amount > 0 then
      Fuel.image = love.graphics.newImage("/images/HUD/fuel10.png")
      Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
      Astronaut.y = Astronaut.y + math.sin(astronautR) * speed      
    elseif Fuel.amount <= 0 then   
      Fuel.image = love.graphics.newImage("/images/HUD/fuel0.png")
      Astronaut.image =  love.graphics.newImage("/images/player/astronaut.png")
    end 
  end

  force = checkGravity(Planets[1].mass)
  angle = angleTo(Planets[1])

  addVector(force, angle)
   
end
 

function love.draw()
  love.graphics.draw(Fuel.image, Fuel.x, Fuel.y)
  love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y,astronautR,.6,.6)
	
	for i in pairs(Asteroids) do
		love.graphics.draw(Asteroids[i].image, Asteroids[i].x, Asteroids[i].y,0,.75,.75)
	end
		
	for j in pairs(Planets) do
		love.graphics.draw(Planets[j].image, Planets[j].x, Planets[j].y,0,2.5,2.5)
	end
	
    love.graphics.print(text, 300,300)
    love.graphics.print('Score: ', 670, 10, 0, 2, 2)
    love.graphics.print(intScore, 760, 10, 0, 2, 2)  
    
    
end