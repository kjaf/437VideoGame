sound = love.audio.newSource("sounds/menuSelect.wav", "static")
return {
	new = function()
		return {
			items = {},
			selected = 1,
			animOffset = 0,
			addItem = function(self, item)
				table.insert(self.items, item)
			end,
			update = function(self, dt)
				self.animOffset = self.animOffset / (1 + dt*10)
			end,
			draw = function(self, x, y)
				local height = 20
				local width = 150
				
				love.graphics.setColor(255, 255, 255, 128)
				love.graphics.rectangle('fill', x, y + height*(self.selected-1) + (self.animOffset * height), width, height)
				
				for i, item in ipairs(self.items) do
					if self.selected == i then
						love.graphics.setColor(255, 255, 255)
					else
						love.graphics.setColor(255, 255, 255)
					end
					love.graphics.print(item.name, x + 5, y + height*(i-1) + 5)
				end
			end,
			keypressed = function(self, key)
				if key == 'up' then
					if self.selected > 1 then
						sound:play()
						self.selected = self.selected - 1
						self.animOffset = self.animOffset + 1
					else
						sound:play()
						self.selected = #self.items
						self.animOffset = self.animOffset - (#self.items-1)
					end
				elseif key == 'down' then
					if self.selected < #self.items then
						sound:play()
						self.selected = self.selected + 1
						self.animOffset = self.animOffset - 1
					else
						sound:play()
						self.selected = 1
						self.animOffset = self.animOffset + (#self.items-1)
					end
				elseif key == 'return' then
					if self.items[self.selected].action then
						self.items[self.selected]:action()
					end
				end
			end
		}
	end
}