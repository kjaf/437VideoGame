Menu = require 'menu'

function love.load()
    startGame = false
    menuScreen = true
    instructionPage = false
  	menuMusic = love.audio.newSource("sounds/menu.wav")
  	gameMusic = love.audio.newSource("sounds/backgroundMusic.wav")
  	jetpackNoise = love.audio.newSource("sounds/jetpack.wav")
  	fuelpack = love.audio.newSource("sounds/fuelpack.wav")
  	pickup = love.audio.newSource("sounds/pickup.wav")
  	ship = love.audio.newSource("sounds/ship.mp3")
  	death = love.audio.newSource("sounds/death.wav")
	background = love.graphics.newImage("images/space.png")
	background = love.graphics.newImage("images/space.png")
	Asteroids = {}
    Planets = {}
	Friends = {}
	Fuel = {}
    score = 60
    timer = 10
    level = 1
	saved = 0
    force = 0 
    gravityConstant = .225
	angle = 0
    speed = 2
    astronautR = 0
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
			local mass = love.math.random(500,2000)
			Planets[i] = {}
			Planets[i].image = love.graphics.newImage("/images/planets/planet" .. love.math.random(1, 3) .. ".png")
			Planets[i].width = Planets[i].image:getWidth()
			Planets[i].height = Planets[i].image:getHeight()
			--Planets[i].x = love.math.random(100, love.graphics.getWidth() - 200)
			--Planets[i].y = love.math.random(100, love.graphics.getHeight() - 200)
			Planets[i].mass = mass
			if(mass < 1000) then
				Planets[i].scale = 2
			end
			if(mass >1000 and mass <1500) then
				Planets[i].scale = 2.5
			end
			if(mass > 1500) then
				Planets[i].scale = 3
			end
		end
		
		return Planets
    end
	
	function createAsteroids(planets, maximum)
		for i in pairs(planets) do
			for j = 1, love.math.random(1, maximum) do
				Asteroids[j] = {}
				Asteroids[j].image = love.graphics.newImage("/images/planets/asteroid" .. love.math.random(1, 3) .. ".png")
				Asteroids[j].width = Asteroids[j].image:getWidth()
				Asteroids[j].height = Asteroids[j].image:getHeight()
				Asteroids[j].x = Planets[i].x + love.math.random(-100, 100)
				Asteroids[j].y = Planets[i].y + love.math.random(60, 100)
				Asteroids[j].mass = 1000
				Asteroids[j].angle = 0
				Asteroids[j].radius = 2
				Asteroids[j].speed = love.math.random(1, 6) / 100
			end
		end
		return Asteroids
	end
	
	function createShip()
		Ship = {}
		Ship.image =  love.graphics.newImage("/images/player/ship.png")
		Ship.width = Ship.image:getWidth()
		Ship.height = Ship.image:getHeight()
		Ship.x = love.math.random(600, love.graphics.getWidth()-100)
    	Ship.y = love.math.random(400, love.graphics.getHeight()-100)
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
			Friends[i].x = love.math.random(25, love.graphics.getWidth() - 25)
			Friends[i].y = love.math.random(25, love.graphics.getHeight() - 25)
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
			Fuel[i].x = love.math.random(25, love.graphics.getWidth() - 25)
			Fuel[i].y = love.math.random(25, love.graphics.getHeight() - 25)
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
	
	-- CREATE OBJECTS --
	Astronaut = createAstronaut()
	Planets = createPlanets(3)
	Planets[1].x = 500
	Planets[1].y = 400
	Planets[2].x = 500
	Planets[2].y = 200
	Planets[3].x = 200
	Planets[3].y = 300
	Asteroids = createAsteroids(Planets, 3)
	Friends = createFriends(3)
	FuelGauge = createFuelGauge(100)
	Fuel = createFuel(2)
	Ship = createShip()
	
    function checkGravity(planet)
		local dist = checkDistance(planet)
		local dir = angleTo(planet)
		local force = ((planet.mass * Astronaut.mass) / (dist * dist)) * gravityConstant
		addVector(dir, force)

    end


    function angleTo(Planets)
		return math.deg(math.atan2(Planets.y-Astronaut.y,Planets.x-Astronaut.x)) + 90
    end
    
    function checkDistance(planet)
		local dx = planet.x - Astronaut.x
		local dy = planet.y - Astronaut.y
		local distance =  math.sqrt(dx * dx + dy * dy)
		return distance
    end


    function addVector(degrees, thrust)
		degrees = degrees - 90
		angle = degrees * math.pi/180
		newDX = thrust * math.cos(angle)
		newDY = thrust * math.sin(angle)

		Astronaut.dx = Astronaut.dx + newDX
		Astronaut.dy = Astronaut.dy + newDY
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

    function asteroidUpdate(asteroid, planet, dt)
    	asteroid.angle = asteroid.angle + asteroid.speed
    	if asteroid.angle >= 360 then 
    		asteroid.angle = 0
    	end 

    	dx = asteroid.radius * math.deg(math.sin(asteroid.angle))
    	dy = asteroid.radius * math.deg(math.cos(asteroid.angle))
    	asteroid.x = planet.x + dx 
    	asteroid.y = planet.y + dy
    end
	
	function hide(sprite)
		sprite.x = 10000
		sprite.y = 10000
	end
	
	function die()
	  level = 3
	  timer = 10
	  hide(Astronaut)
	  FuelGauge.amount = 0
	end
	
	function collectFuel(fuel)
		hide(fuel)
		FuelGauge.amount = 100
	end
	
	function collectFriend(friend)
		hide(friend)
		score = score + 100
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
			jetpackNoise:setVolume(.2)
			FuelGauge.amount = FuelGauge.amount - .25
			Astronaut.image = love.graphics.newImage("/images/player/boosting.png")  
			checkFuel() 
		end
	end
	
	function love.keypressed(key)
    	menu:keypressed(key)
    end

    function love.keyreleased(key)
     	if key == "space" then
     		love.audio.stop(jetpackNoise)
        	Astronaut.image = love.graphics.newImage("/images/player/astronaut.png")
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
			if isColliding(Astronaut, .6, Planets[i], 1.75) then
				if level == 1 then
					death:play()
				end
				die()
			end
		end
		
		for j in pairs(Asteroids) do
			if isColliding(Astronaut, .6, Asteroids[j], .75) then
				if level == 1 then
					death:play()
				end 
				die()
			end
		end
		
		for k in pairs(Friends) do
			if isColliding(Astronaut, .6, Friends[k], .6) then 
				pickup:play()
				collectFriend(Friends[k])
			end
		end
		
		for l in pairs(Fuel) do
			if isColliding(Astronaut, .6, Fuel[l], 1) then
				fuelpack:play()
				collectFuel(Fuel[l])
			end
		end
		
		if isColliding(Astronaut, .6, Ship, 1) then
			level = 2
			timer = 10
			hide(Astronaut)
			hiScore = math.ceil(score)
			FuelGauge.amount = 0
		end
		
	end
	
	function checkFuel()
		if FuelGauge.amount > 0 then 
			jetpackNoise:setVolume(.2)
			jetpackNoise:play()
			Astronaut.x = Astronaut.x + math.cos(astronautR) * speed
			Astronaut.y = Astronaut.y + math.sin(astronautR) * speed  
			if FuelGauge.amount > 90 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel100.png")
			elseif FuelGauge.amount <= 90 and FuelGauge.amount > 80 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel90.png")
			elseif FuelGauge.amount <= 80 and FuelGauge.amount > 70 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel80.png")
			elseif FuelGauge.amount <= 70 and FuelGauge.amount > 60 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel70.png")
			elseif FuelGauge.amount <= 60 and FuelGauge.amount > 50 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel60.png")
			elseif FuelGauge.amount <= 50 and FuelGauge.amount > 40 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel50.png")
			elseif FuelGauge.amount <= 40 and FuelGauge.amount > 30 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel40.png")
			elseif FuelGauge.amount <= 30 and FuelGauge.amount > 20 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel30.png")
			elseif FuelGauge.amount <= 20 and FuelGauge.amount > 10 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel20.png")
			elseif FuelGauge.amount <= 10 and FuelGauge.amount > 0 then
				FuelGauge.image = love.graphics.newImage("/images/HUD/fuel10.png")
			end
		else
			FuelGauge.image = love.graphics.newImage("/images/HUD/fuel0.png")
			Astronaut.image =  love.graphics.newImage("/images/player/astronaut.png")
		end
	end


end
 

function love.update(dt)
  --score goes down every update (every second)
  score = score - dt
  timer = timer - dt
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

	for i in pairs(Planets) do 
  		checkGravity(Planets[i])
 	end
 	

 	if(startGame) then
  		astronautUpdate()
  	end


for i in pairs(Asteroids) do 
	asteroidUpdate(Asteroids[i], Planets[i], dt)
end
   
end
 

function love.draw()
  if menuScreen then
  	menuMusic:play()
   	love.graphics.draw(background, 0, 0, 0, .6, .6)
    menu:draw(320, 250)
  end

  if instructionPage then
  	love.graphics.printf(instructions, 170,110, 400, "center")
  end

  if startGame then
  	if level == 1 then
	  	love.audio.stop(menuMusic)
	  	love.audio.stop(menuSound)
	  	gameMusic:setVolume(0.25)
	  	gameMusic:setPitch(0.7)
	  	gameMusic:play()
	  	love.graphics.draw(background, 0, 0, 0, .6, .6)
	  	love.graphics.draw(FuelGauge.image, Fuel.x, Fuel.y)
	  	love.graphics.draw(Astronaut.image, Astronaut.x, Astronaut.y,astronautR,.6,.6)
		love.graphics.draw(Ship.image, Ship.x, Ship.y)  
	  	
	  	for i in pairs(Asteroids) do
	  		love.graphics.draw(Asteroids[i].image, Asteroids[i].x, Asteroids[i].y,0,.75,.75)
	  	end
	  		
	  	for j in pairs(Planets) do
	  		love.graphics.draw(Planets[j].image, Planets[j].x, Planets[j].y,0,Planets[j].scale,Planets[j].scale)
	  	end
		
		for k in pairs(Friends) do
			love.graphics.draw(Friends[k].image, Friends[k].x, Friends[k].y,0,.6,.6)
		end
		
		for l in pairs(Fuel) do
			love.graphics.draw(Fuel[l].image, Fuel[l].x, Fuel[l].y,0,1,1)
		end
	    love.graphics.print('Score: ', 700, 10, 0, 1, 1)
	    love.graphics.print(intScore, 750, 10, 0, 1, 1)
	elseif level == 2 then
		love.graphics.clear()
	  	love.audio.stop(menuSound)
	  	love.audio.stop(gameMusic)
		love.graphics.draw(background, 0, 0, 0, .6, .6)
		love.graphics.print("Congrats you won!\nRestarting in 10 seconds", 320, 250)
		love.graphics.print("Score: ", 320, 280)
		love.graphics.print(hiScore, 360, 280)
		if timer <= 0 then
			love.event.quit('restart')
		end
	elseif level ==3 then
		love.graphics.clear()
		love.audio.stop(menuMusic)
	  	love.audio.stop(menuSound)
	  	love.audio.stop(gameMusic)
		love.graphics.draw(background, 0, 0, 0, .6, .6)
		love.graphics.print("Oh no you lost!\nRestarting in 10 seconds", 320, 250)
		love.graphics.print("Score: 0", 320, 290)
		if timer <= 0 then
			love.event.quit('restart')
		end
	end


  end
    
    
end