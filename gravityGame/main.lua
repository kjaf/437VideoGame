
function love.load()
	background = love.graphics.newImage("images/space.png")
	Asteroids = {}
    Planets = {}
    score = 60
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
		Astronaut.width = Astronaut.image:getWidth()
		Astronaut.height = Astronaut.image:getHeight()
		Astronaut.x = 100
		Astronaut.y = 100
		Astronaut.mass = 1
		Astronaut.dx = 0
		Astronaut.dy = 0 
		Astronaut.speed = 0
		Astronaut.moveAngle = 0
		return Astronaut
	end
	

	function createPlanets(numPlanets)
		for i = 1, numPlanets do
			Planets[i] = {}
			Planets[i].image = love.graphics.newImage("/images/planets/planet" .. math.random(1, 3) .. ".png")
			Planets[i].width = Planets[i].image:getWidth()
			Planets[i].height = Planets[i].image:getHeight()
			Planets[i].x = math.random(100, love.graphics.getWidth() - 100)
			Planets[i].y = math.random(100, love.graphics.getHeight() - 100)
			Planets[i].mass = 2000
		end
		
		return Planets
    end
	
	function createAsteroids(planets, maximum)
		for i in pairs(planets) do
			for j = 1, love.math.random(1, maximum) do
				Asteroids[j] = {}
				Asteroids[j].image = love.graphics.newImage("/images/planets/asteroid" .. math.random(1, 3) .. ".png")
				Asteroids[j].width = Asteroids[j].image:getWidth()
				Asteroids[j].height = Asteroids[j].image:getHeight()
				Asteroids[j].x = Planets[i].x + math.random(-100, 100)
				Asteroids[j].y = Planets[i].y + math.random(60, 100)
				Asteroids[j].mass = 1000
			end
		end
		return Asteroids
	end
	
	function createFuelGauge(amount)
		Fuel = {}
		Fuel.image =  love.graphics.newImage("/images/HUD/fuel100.png")
		Fuel.x = 50
		Fuel.y = 500
		Fuel.amount = amount
		return Fuel
	end
		
	
	Astronaut = createAstronaut()
	Planets = createPlanets(2)
	Asteroids = createAsteroids(Planets, 2)
	Fuel = createFuelGauge(100)
	


    function checkGravity(planet)

      local dist = checkDistance(planet)
      local dir = angleTo(planet)
      local force = ((planet.mass * Astronaut.mass) / (dist * dist))
      addVector(dir, force)
      -- return force
      -- Astronaut.x = Astronaut.x + math.cos(astronautR) * force
      -- Astronaut.y = Astronaut.y + math.sin(astronautR) * force

    end


    function angleTo(Planets)
      -- local diffx = Astronaut.x - Planets.x
      -- local diffy = Astronaut.y - Planets.y
     

        
      -- local radians = math.atan2(diffy,diffx)
      -- local degrees = radians * 180 /math.pi
    
      -- text = radians
      -- return degrees
      return math.deg(math.atan2(Planets.y-Astronaut.y,Planets.x-Astronaut.x)) + 90
    end
    


    function checkDistance(planet)
      local dx = planet.x - Astronaut.x
      local dy = planet.y - Astronaut.y
      local distance =  math.sqrt(dx * dx + dy * dy)
       -- local angle = angleTo(Planets[1])
      return distance
    end


    function addVector(degrees, thrust)
      degrees = degrees - 90
      angle = degrees * math.pi/180
      newDX = thrust * math.cos(angle)
      newDY = thrust * math.sin(angle)

      Astronaut.dx = Astronaut.dx + newDX
      Astronaut.dy = Astronaut.dy + newDY

      -- local x = Astronaut.x + (math.sin(math.rad(degrees)))
      -- local y = Astronaut.y + (math.cos(math.rad(degrees)))

      -- Astronaut.dx = Astronaut.dx + x 
      -- Astronaut.dy = Astronaut.dy + y 
      
      calcSpeedAngle()
    end 

    function calcSpeedAngle()
      Astronaut.speed = math.sqrt((Astronaut.dx*Astronaut.dx) +(Astronaut.dy*Astronaut.dy))
      Astronaut.moveAngle = math.atan2(Astronaut.dy, Astronaut.dx)
    end

    function astronautUpdate()
      Astronaut.x = Astronaut.x + Astronaut.dx 
      Astronaut.y = Astronaut.y + Astronaut.dy
    end
	
	function die()
	  Astronaut.x = 1000
	  Astronaut.y = 1000
	end
	
	function checkKeys()
		if love.keyboard.isDown("right") then
			astronautR = astronautR + .05
		end

		if love.keyboard.isDown("left") then
			astronautR = astronautR + -.05
		end

		if (love.keyboard.isDown("space")) then 
			Fuel.amount = Fuel.amount - .25
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
	end


	function isColliding(spriteA, spriteB)
		text = spriteA.x
		text1 = spriteB.x
		aLeft = spriteA.x
		aRight = spriteA.x + spriteA.width * .6
		aTop = spriteA.y
		aBottom = spriteA.y + spriteA.height * .6
		bLeft = spriteB.x
		bRight = spriteB.x + spriteB.width * 2
		bTop = spriteB.y
		bBottom = spriteB.y + spriteB.height * 2
		
		collision = true
		if aBottom < bTop or
			aTop > bBottom or
			aRight < bLeft or
			aLeft > bRight then
			collision = false
		end
		return collision
	end
				
	function checkCollisions()
		for i in pairs(Planets) do
			if isColliding(Astronaut, Planets[i]) then
				die()
			end
		end
		
		for j in pairs(Asteroids) do
			if isColliding(Astronaut, Asteroids[j]) then 
				die()
			end
		end
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

  checkCollisions()
  checkKeys()

  -- force = checkGravity(Planets[1].mass)
  -- angle = angleTo(Planets[1])

  -- addVector(force, angle)

  checkGravity(Planets[1])
  astronautUpdate()
   
end
 

function love.draw()
	love.graphics.draw(background, 0, 0, 0, .6, .6)
	love.graphics.draw(Fuel.image, Fuel.x, Fuel.y)
	love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y,astronautR,.6,.6)
	
	for i in pairs(Asteroids) do
		love.graphics.draw(Asteroids[i].image, Asteroids[i].x, Asteroids[i].y,0,.75,.75)
	end
		
	for j in pairs(Planets) do
		love.graphics.draw(Planets[j].image, Planets[j].x, Planets[j].y,0,2.5,2.5)
	end
	
    love.graphics.print(text, 300,300)
	love.graphics.print(text1, 350, 350)
    love.graphics.print('Score: ', 670, 10, 0, 2, 2)
    love.graphics.print(intScore, 760, 10, 0, 2, 2)  
    
    
end