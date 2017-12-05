
Menu = require 'menu'

function love.load()
    startGame = false
    menuScreen = true
    instructionPage = false
  	music = love.audio.newSource("sounds/menu.wav")
	background = love.graphics.newImage("images/space.png")
	Asteroids = {}
    Planets = {}
	Friends = {}
	Fuel = {}
    score = 60
	saved = 0
    force = 0 
    gravityConstant = .3
	angle = 0
    speed = 2
    astronautR = 0
    text = "nothing"
    text1 = "nothing"

    instructions = "Welcome to Gravity!\nYou're an astronaut who has been stranded in space!!\nYou must get back to your ship using a limited amount of fuel.\nUse the planet's orbits to help get you back to your ship!\nAlong the way, be sure to pick up your fellow astronauts!"

    --MENU--
    menu = Menu.new()
        menu:addItem{
        	name = 'Start Game',
        	action = function()
          		startGame = true
          		menuScreen = false
        	end
    	}
    	menu:addItem{
        	name = 'Instructions',
        	action = function()
        		instructionPage = true
        	end
      	}
      	menu:addItem{
        	name = 'Quit',
        	action = function()
          		love.event.push('quit')
        	end
      	}
    --MENU--

    --MENU KEY PRESS--
    function love.keypressed(key)
    	menu:keypressed(key)
    end
    --MENU KEY PRESS--

    function love.keyreleased(key)
     	if key == "space" then
        	Astronaut.image = love.graphics.newImage("/images/player/astronaut.png")
      	end
    end


    love.window.setMode(800,600)
    love.window.setTitle('Gravity')
	
    function createAstronaut()
		Astronaut = {}
		Astronaut.image =  love.graphics.newImage("/images/player/astronaut.png")
		Astronaut.width = Astronaut.image:getWidth()
		Astronaut.height = Astronaut.image:getHeight()
		Astronaut.x = 10
		Astronaut.y = 10
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
			Planets[i].x = math.random(100, love.graphics.getWidth() - 200)
			Planets[i].y = math.random(100, love.graphics.getHeight() - 200)
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
				Asteroids[j].angle = 0
				Asteroids[j].radius = .08
			end
		end
		return Asteroids
	end
	
	function createShip()
		Ship = {}
		Ship.image =  love.graphics.newImage("/images/player/ship.png")
		Ship.width = Ship.image:getWidth()
		Ship.height = Ship.image:getHeight()
		Ship.x = math.random(600, love.graphics.getWidth()-100)
    	Ship.y = math.random(400, love.graphics.getHeight()-100)
		Ship.mass = 1
		Ship.speed = 0
		return Ship
	end
	
	function createFriends(numFriends)
		for i = 1, numFriends do
			Friends[i] = {}
			Friends[i].image = love.graphics.newImage("/images/player/astronaut2.png")
			Friends[i].width = Friends[i].image:getWidth()
			Friends[i].height = Friends[i].image:getHeight()
			Friends[i].x = math.random(100, love.graphics.getWidth() - 100)
			Friends[i].y = math.random(100, love.graphics.getHeight() - 100)
			Friends[i].mass = 1
		end
		return Friends
	end
	
	function createFuel(numFuel)
		for i = 1, numFuel do
			Fuel[i] = {}
			Fuel[i].image = love.graphics.newImage("/images/player/fuel.png")
			Fuel[i].width = Fuel[i].image:getWidth()
			Fuel[i].height = Fuel[i].image:getHeight()
			Fuel[i].x = math.random(100, love.graphics.getWidth() - 100)
			text = Fuel[i].x
			Fuel[i].y = math.random(100, love.graphics.getHeight() - 100)
			Fuel[i].mass = 1
		end
		return Fuel
	end	
	
	function createFuelGauge(amount)
		FuelGauge = {}
		FuelGauge.image =  love.graphics.newImage("/images/HUD/fuel100.png")
		FuelGauge.x = 50
		FuelGauge.y = 500
		FuelGauge.amount = amount
		return FuelGauge
	end
		
	Astronaut = createAstronaut()
	Planets = createPlanets(2)
	Asteroids = createAsteroids(Planets, 2)
	Friends = createFriends(1)
	FuelGauge = createFuelGauge(100)
	Fuel = createFuel(1)
	Ship = createShip()
	
	


    function checkGravity(planet)

      local dist = checkDistance(planet)
      local dir = angleTo(planet)
      local force = ((planet.mass * Astronaut.mass) / (dist * dist)) * gravityConstant
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

    function asteroidUpdate(asteroid, planet)
    	-- asteriod.angle = asteriod.angle + 90
    	-- local angle = asteriod.angle * math.pi/180
    	-- text = angle
    	-- local newDX = math.cos(angle)
    	-- local newDy = math.sin(angle)
    	-- asteriod.x = asteriod.x + newDX    	
    	-- asteriod.y = asteriod.y + newDY
    	asteroid.angle = asteroid.angle + .05
    	if asteroid.angle >= 360 then 
    		asteroid.angle = 0
    	end 
    	
    	dx = asteroid.radius * math.deg(math.sin(asteroid.angle))
    	dy = asteroid.radius * math.deg(math.cos(asteroid.angle))
    	asteroid.x = asteroid.x +  dx 
    	asteroid.y = asteroid.y + dy 
    end
	
	function die()
	  Astronaut.x = 1000
	  Astronaut.y = 1000
	  FuelGauge.amount = 0
	end
	
	function collectFuel(fuel)
		fuel.x = 1000
		fuel.y = 1000
		FuelGauge.amount = 100
	end
	
	function collectFriend(friend)
		friend.x = 1000
		friend.y = 1000
		saved = saved + 1
	end
	
	function checkKeys()
		if love.keyboard.isDown("right") then
			astronautR = astronautR + .05
		end

		if love.keyboard.isDown("left") then
			astronautR = astronautR + -.05
		end

		if (love.keyboard.isDown("space")) then 
			FuelGauge.amount = FuelGauge.amount - .25
			Astronaut.image = love.graphics.newImage("/images/player/boosting.png")  
			if FuelGauge.amount <= 100 and FuelGauge.amount > 90 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel100.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed     
			elseif FuelGauge.amount <= 90 and FuelGauge.amount > 80 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel90.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed    
			elseif FuelGauge.amount <= 80 and FuelGauge.amount > 70 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel80.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed    
			elseif FuelGauge.amount <= 70 and FuelGauge.amount > 60 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel70.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed    
			elseif FuelGauge.amount <= 60 and FuelGauge.amount > 50 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel60.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed       
			elseif FuelGauge.amount <= 50 and FuelGauge.amount > 40 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel50.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed       
			elseif FuelGauge.amount <= 40 and FuelGauge.amount > 30 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel40.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed       
			elseif FuelGauge.amount <= 30 and FuelGauge.amount > 20 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel30.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed     
			elseif FuelGauge.amount <= 20 and FuelGauge.amount > 10 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel20.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed    
			elseif FuelGauge.amount <= 10 and FuelGauge.amount > 0 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel10.png")
				Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
				Astronaut.y = Astronaut.y + math.sin(astronautR) * speed      
			elseif FuelGauge.amount <= 0 then   
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel0.png")
				Astronaut.image =  love.graphics.newImage("/images/player/astronaut.png")
			end 
		end
	end

	
	function isColliding(spriteA, scaleA, spriteB, scaleB)
		aLeft = spriteA.x
		aRight = spriteA.x + spriteA.width * scaleA
		aTop = spriteA.y
		aBottom = spriteA.y + spriteA.height * scaleA
		bLeft = spriteB.x
		bRight = spriteB.x + spriteB.width * scaleB
		bTop = spriteB.y
		bBottom = spriteB.y + spriteB.height * scaleB
		
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
			if isColliding(Astronaut, .6, Planets[i], 1.5) then
				die()
			end
		end
		
		for j in pairs(Asteroids) do
			if isColliding(Astronaut, .6, Asteroids[j], .75) then 
				die()
			end
		end
		
		for k in pairs(Friends) do
			if isColliding(Astronaut, .6, Friends[k], .6) then 
				collectFriend(Friends[k])
			end
		end
		
		for l in pairs(Fuel) do
			if isColliding(Astronaut, .6, Fuel[l], 1) then
				collectFuel(Fuel[l])
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

  menu:update(dt)
  checkCollisions()
  checkKeys()

  -- force = checkGravity(Planets[1].mass)
  -- angle = angleTo(Planets[1])

  -- addVector(force, angle)
if(love.keyboard.isDown("space") ~= true) then
	for i in pairs(Planets) do 
  		checkGravity(Planets[i])
 	end

  	astronautUpdate()
end


for i in pairs(Asteroids) do 
	asteroidUpdate(Asteroids[i])
end
   
end
 

function love.draw()
  if menuScreen then
  	music:play()
   	love.graphics.draw(background, 0, 0, 0, .6, .6)
    menu:draw(320, 250)
  end

  if instructionPage then
  	love.graphics.printf(instructions, 170,110, 400, "center")
  end

  if startGame then
  	love.audio.stop(music)
  	love.audio.stop(sound)
  	love.graphics.draw(background, 0, 0, 0, .6, .6)
  	love.graphics.draw(FuelGauge.image, Fuel.x, Fuel.y)
  	love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y,astronautR,.6,.6)
	love.graphics.draw(Ship.image, Ship.x, Ship.y)  
  	
  	for i in pairs(Asteroids) do
  		love.graphics.draw(Asteroids[i].image, Asteroids[i].x, Asteroids[i].y,0,.75,.75)
  	end
  		
  	for j in pairs(Planets) do
  		love.graphics.draw(Planets[j].image, Planets[j].x, Planets[j].y,0,2.5,2.5)
  	end
	
	for k in pairs(Friends) do
		love.graphics.draw(Friends[k].image, Friends[k].x, Friends[k].y,0,.6,.6)
	end
	
	for l in pairs(Fuel) do
		love.graphics.draw(Fuel[l].image, Fuel[l].x, Fuel[l].y,0,1,1)
	end
  	
    love.graphics.print(text, 300,300)
  	love.graphics.print(text1, 350, 350)
    love.graphics.print('Score: ', 670, 10, 0, 2, 2)
    love.graphics.print(intScore, 760, 10, 0, 2, 2)

  end
    
    
end