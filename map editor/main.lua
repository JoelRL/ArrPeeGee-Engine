require "system_messages"
require "camera"
require "file_controller"

function love.load()
	maxW, maxH = love.graphics.getDimensions()
	
	tiles_sprSheet = love.graphics.newImage("/tiles.png")
	
	tileSD = 32
	
	local tile_calc = (tiles_sprSheet:getWidth() / tileSD) * (tiles_sprSheet:getHeight() / tileSD)
	
	tiles_Num = tile_calc + 1
	
	tiles_spr = {}
	
	local x = 0
	local y = 0
	
	for i=1, tiles_Num do
		local v = love.graphics.newQuad(x*tileSD,y*tileSD,tileSD,tileSD,tiles_sprSheet:getWidth(),tiles_sprSheet:getHeight())
		table.insert(tiles_spr,v)
		
		x = x + 1
		
		if x * tileSD > tiles_sprSheet:getWidth() then
			y = y + 1
			x = 0
		end
	end

	system_messages.load()
	
	tileS = 32
	
	map_width = 23
	map_height = 16
	
	tileSelected = 1
	
	dir = love.filesystem.getSaveDirectory()
	
	menuXoffset = 0
	
	drawMode = 1
	
	mainMode = 1
	
	showGrid = true
	
	menuOffsetMove = false
	
	menuOffsetMoveD = 0
	
	tiles_SelectOffset = 0
	
	tilesDraw = 10
	
	mapLoadID = nil
	
	resetTileMap()
	
	collsX = 0
	collsY = 0
	collsX2 = 0
	collsY2 = 0
	
	entity_drawTYP = 1
	entity_drawID = 0
	
	loadingMap = false
	
	mapLoadedID = nil
	
	drawLines = false
end

function love.draw()

	if mainMode == 1 then
		love.graphics.setColor(252,252,252)
	else
		love.graphics.setColor(252,252,252,70)
	end
	love.graphics.setLineWidth(1)
	
	camera:set()
	
	for y=1, #tileMap do
		for x=1, #tileMap[y] do
			if tileMap[y][x] ~= 0 then
				love.graphics.draw(tiles_sprSheet,tiles_spr[tileMap[y][x]],(x*tileS)+gridOffsetX,(y*tileS)+gridOffsetY,0,tileS/tileSD,tileS/tileSD)
			end
		end
	end
	
	if showGrid then
		for y=1, map_height do
			for x=1, map_width do
				love.graphics.rectangle("line",(x*tileS)+gridOffsetX,(y*tileS)+gridOffsetY,tileS,tileS)
			end
		end
	else
		love.graphics.rectangle("line",tileS+gridOffsetX,tileS+gridOffsetY,map_width*tileS,map_height*tileS)
	end
	
	if mainMode == 2 or mainMode == 3 then
		love.graphics.setColor(252,252,252)
		
		love.graphics.rectangle("line",tileS+gridOffsetX,tileS+gridOffsetY,map_width*tileS,map_height*tileS)
	end
	
	camera:unset()
	
	love.graphics.setColor(70,70,70)
	
	love.graphics.rectangle("fill",-5,60,65,480)
	
	love.graphics.rectangle("fill",(maxW-60)-menuXoffset,60,300,480)
	
	love.graphics.setColor(20,20,20)
	
	love.graphics.rectangle("fill",(maxW+35)-menuXoffset,80,120,45,5,5)
	
	love.graphics.rectangle("fill",(maxW+35)-menuXoffset,150,120,45,5,5)
	
	love.graphics.rectangle("fill",(maxW+35)-menuXoffset,220,120,45,5,5)
	
	love.graphics.rectangle("fill",(maxW+35)-menuXoffset,290,120,45,5,5)
	
	love.graphics.rectangle("fill",(maxW+35)-menuXoffset,480,120,45,5,5)
	
	love.graphics.rectangle("fill",(maxW-50)-menuXoffset,80,40,40,5,5)
	
	love.graphics.rectangle("fill",(maxW-50)-menuXoffset,140,40,40,5,5)
	
	love.graphics.rectangle("fill",(maxW-50)-menuXoffset,470,40,40,5,5)
	
	love.graphics.rectangle("fill",(maxW-50)-menuXoffset,350,40,40,5,5)
	
	love.graphics.rectangle("fill",(maxW-50)-menuXoffset,410,40,40,5,5)
	
	love.graphics.setColor(252,252,252)
	
	love.graphics.rectangle("line",-5,60,65,480)
	
	love.graphics.rectangle("line",(maxW-60)-menuXoffset,60,300,480)
	
	love.graphics.circle("line",(maxW-40)-menuXoffset,maxH/2,15)
	
	if drawMode == 1 then
		love.graphics.setLineWidth(5)
	else
		love.graphics.setLineWidth(2)
	end
	
	love.graphics.rectangle("line",(maxW-50)-menuXoffset,80,40,40,5,5)
	
	if drawMode == 0 then
		love.graphics.setLineWidth(5)
	else
		love.graphics.setLineWidth(2)
	end
	
	love.graphics.rectangle("line",(maxW-50)-menuXoffset,140,40,40,5,5)
	
	love.graphics.setLineWidth(2)
	
	love.graphics.rectangle("line",(maxW-50)-menuXoffset,470,40,40,5,5)
	
	love.graphics.rectangle("line",(maxW-50)-menuXoffset,350,40,40,5,5)
	
	love.graphics.rectangle("line",(maxW-50)-menuXoffset,410,40,40,5,5)
	
	love.graphics.rectangle("line",(maxW+35)-menuXoffset,80,120,45,5,5)
	
	love.graphics.rectangle("line",(maxW+35)-menuXoffset,150,120,45,5,5)
	
	love.graphics.rectangle("line",(maxW+35)-menuXoffset,220,120,45,5,5)
	
	love.graphics.rectangle("line",(maxW+35)-menuXoffset,290,120,45,5,5)
	
	love.graphics.rectangle("line",(maxW+35)-menuXoffset,480,120,45,5,5)
	
	love.graphics.printf("Pen",(maxW-50)-menuXoffset,93,40,"center")
	
	love.graphics.printf("Erase",(maxW-50)-menuXoffset,153,40,"center")
	
	love.graphics.printf("Tiles",(maxW-50)-menuXoffset,363,40,"center")
	
	love.graphics.printf("Colls",(maxW-50)-menuXoffset,423,40,"center")
	
	love.graphics.printf("Entity",(maxW-50)-menuXoffset,483,40,"center")
	
	love.graphics.printf("resize map",(maxW+35)-menuXoffset,95,120,"center")
	
	love.graphics.printf("export map",(maxW+35)-menuXoffset,165,120,"center")
	
	love.graphics.printf("load map",(maxW+35)-menuXoffset,235,120,"center")
	
	if showGrid then
		love.graphics.printf("hide grid",(maxW+35)-menuXoffset,305,120,"center")
	else 
		love.graphics.printf("show grid",(maxW+35)-menuXoffset,305,120,"center")
	end
	
	love.graphics.printf("--CLEAR MAP--",(maxW+35)-menuXoffset,495,120,"center")
	
	if mainMode == 1 then
		love.graphics.setColor(252,252,252)
	else
		love.graphics.setColor(252,252,252,80)
	end
	
	if mainMode ~= 3 then
		for i=1, #tiles_spr do
			if i > tilesDraw - 10 and i < tilesDraw then
				local x = 15
				local y = 90*(0.55*i)+36
				love.graphics.draw(tiles_sprSheet,tiles_spr[i],x,(y-tiles_SelectOffset)+(tiles_SelectOffset/10))
				
				if i == tileSelected then
					love.graphics.rectangle("line",x,(y-tiles_SelectOffset)+(tiles_SelectOffset/10),32,32)
				end
			end
		end
	else
		love.graphics.setColor(252,0,0)
		
		love.graphics.rectangle("fill",15,85,32,32)
		
		love.graphics.setColor(252,252,252)
		
		if entity_drawTYP == 1 then
			love.graphics.rectangle("line",15,85,32,32)
		end
		
		love.graphics.printf("EN",15,95,32,"center")
		
		love.graphics.setColor(0,252,0)
		
		love.graphics.rectangle("fill",15,135,32,32)
		
		love.graphics.setColor(252,252,252)
		
		if entity_drawTYP == 2 then
			love.graphics.rectangle("line",15,135,32,32)
		end
		
		love.graphics.printf("EV",15,145,32,"center")
	end
	
	if mainMode == 2 or mainMode == 3 then
	
		camera:set()
	
		if mainMode == 3 then
			love.graphics.setColor(0,252,0,150)
		elseif mainMode == 2 then
			love.graphics.setColor(0,252,0,80)
		end
		
		for y=1, #eventsMap do
			for x=1, #eventsMap[y] do
				if eventsMap[y][x] ~= 0 then
					love.graphics.rectangle("fill",(x*tileS)+gridOffsetX,(y*tileS)+gridOffsetY,tileS,tileS)
				end
			end
		end
	
		if mainMode == 2 then
			love.graphics.setColor(252,252,252,252)
		elseif mainMode == 3 then
			love.graphics.setColor(252,252,252,100)
		end
		
		for i, v in ipairs(collsMap) do
			love.graphics.rectangle("fill",v.x,v.y,v.w,v.h)
		end
		
		love.graphics.rectangle("fill",collsX,collsY,collsX2-collsX,collsY2-collsY)
		
		for i, v in ipairs(entityMap) do
			if mainMode == 3 then
				love.graphics.setColor(252,0,0,252)
			elseif mainMode == 2 then
				love.graphics.setColor(252,0,0,100)
			end
		
			love.graphics.rectangle("fill",v.x,v.y,32,48)
			
			if mainMode == 3 then
				love.graphics.setColor(252,252,252,252)
			elseif mainMode == 2 then
				love.graphics.setColor(252,252,252,100)
			end
			
			love.graphics.print("#"..v.id,v.x+7,v.y+16)
		end
		
		if mainMode == 3 then
			if entity_drawTYP == 1 then
				if drawMode == 1 then
					if entity_drawID ~= 0 then
						love.graphics.setColor(252,0,0,120)
						love.graphics.rectangle("fill",love.mouse.getX()+camera.x,love.mouse.getY()+camera.y,32,48)
						love.graphics.setColor(252,252,252,120)
						love.graphics.print("#"..entity_drawID,love.mouse.getX()+7+camera.x,love.mouse.getY()+16+camera.y)
					end
				end
			end
		end
		
		camera:unset()
	end
	
	love.graphics.setColor(252,252,252,100)
	
	if drawLines then
		love.graphics.line(maxW/2,0,maxW/2,maxH)
		love.graphics.line(0,maxH/2,maxW,maxH/2)
	end
	
	love.graphics.setColor(252,252,252)
	
	love.graphics.setLineWidth(3)
	system_messages.draw()

	debug_print()
end

function debug_print()
	love.graphics.print(map_width.."|"..map_height,0,20)
	
	love.graphics.print("MX: "..love.mouse.getX().." | MY: "..love.mouse.getY())
	
	love.graphics.print("CX: "..camera.x.." , CY: "..camera.y.." | CXr: "..math.floor(camera.x/tileS).." , CYr: "..math.floor(camera.y/tileS),0,40)
end

function love.update(dt)
	
	if mainMode == 1 then
		if map_width * tileS > maxW - (tileS * 2) or map_height * tileS > maxH - (tileS * 2) then
			local num = (maxW - (map_width*tileS))-(maxH - (map_height*tileS))
			tileS = tileS - (num / 100)
		end
		
		gridOffsetX = ((maxW / 2) - ((map_width / 2)*tileS)) - tileS
		gridOffsetY = ((maxH / 2) - ((map_height / 2)*tileS)) - tileS
		camera.x = 0
		camera.y = 0
	elseif mainMode == 2 or mainMode == 3 then
		tileS = tileSD
		gridOffsetX = 0
		gridOffsetY = 0
		
		if love.keyboard.isDown("right") then
			camera.x = camera.x - 3
		elseif love.keyboard.isDown("left") then
			camera.x = camera.x + 3
		end
		
		if love.keyboard.isDown("up") then
			camera.y = camera.y + 1
		elseif love.keyboard.isDown("down") then
			camera.y = camera.y - 1
		end
	end
	
	if #messages == 0 then
		if mainMode == 1 then
			if love.mouse.isDown(1) then
				local mx, my = love.mouse.getPosition()
				
				for y=1, #tileMap do
					for x=1, #tileMap[y] do
						local Tx = (x * tileS) + gridOffsetX
						local Ty = (y * tileS) + gridOffsetY
						
						if menuXoffset > 0 then
							if mx > (maxW-60)-menuXoffset and mx < (maxW-60)-menuXoffset + 300 and my > 60 and my < 60 + 480 then
								return
							end
						end
						
						if mx > Tx and mx < Tx + tileS and my > Ty and my < Ty + tileSD then
							if drawMode == 1 then
								tileMap[y][x] = tileSelected
							elseif drawMode == 0 then
								tileMap[y][x] = 0
							elseif drawMode == 2 then
								for y1=1, #tileMap do
									for x1=1, #tileMap[y1] do
										if tileMap[y1][x1] == 0 then
											tileMap[y1][x1] = tileSelected
										end
									end
								end
							end
						end
					end
				end
			end
			
			if love.mouse.isDown(2) then
				local mx, my = love.mouse.getPosition()
				
				for y=1, #tileMap do
					for x=1, #tileMap[y] do
						local Tx = (x * tileS) + gridOffsetX
						local Ty = (y * tileS) + gridOffsetY
						
						if menuXoffset > 0 then
							if mx > (maxW-60)-menuXoffset and mx < (maxW-60)-menuXoffset + 300 and my > 60 and my < 60 + 480 then
								return
							end
						end
						
						if mx > Tx and mx < Tx + tileS and my > Ty and my < Ty + tileSD then
							tileMap[y][x] = 0
						end
					end
				end
			end
			
			local touches = love.touch.getTouches()
		
			for i,v in ipairs(touches) do
				local mx, my = love.touch.getPosition(v)
				
				for y=1, #tileMap do
					for x=1, #tileMap[y] do
						local Tx = (x * tileS) + gridOffsetX
						local Ty = (y * tileS) + gridOffsetY
						
						if menuXoffset > 0 then
							if mx > (maxW-60)-menuXoffset and mx < (maxW-60)-menuXoffset + 300 and my > 60 and my < 60 + 480 then
								return
							end
						end
						
						if mx > Tx and mx < Tx + tileS and my > Ty and my < Ty + tileSD then
							if drawMode == 1 then
								tileMap[y][x] = tileSelected
							elseif drawMode == 0 then
								tileMap[y][x] = 0
							elseif drawMode == 2 then
								for y1=1, #tileMap do
									for x1=1, #tileMap[y1] do
										if tileMap[y1][x1] == 0 then
											tileMap[y1][x1] = tileSelected
										end
									end
								end
							end
						end
					end
				end
			end
		elseif mainMode == 2 then
			if drawMode == 1 then
				if collsX ~= 0 and collsY ~= 0 then
					if love.mouse.isDown(1) then
						local mx, my = love.mouse.getPosition()
						
						--if mx > tileS+gridOffsetX and mx < tileS+gridOffsetX + map_width*tileS and my > tileS+gridOffsetY and my < tileS+gridOffsetY + map_height*tileS then
							collsX2 = mx + camera.x
							collsY2 = my + camera.y
						--end
					else
						local t = {x=collsX,y=collsY,w=collsX2 - collsX,h=collsY2 - collsY}
				
						table.insert(collsMap,t)
						
						collsX = 0
						collsY = 0
						collsX2 = 0
						collsY2 = 0
					end
				end
			end
		end
	end
	
	if menuOffsetMove then
		if menuOffsetMoveD == 0 then
			menuXoffset = menuXoffset + 18
			if menuXoffset > 190 then
				menuXoffset = 185
				menuOffsetMoveD = 1
				menuOffsetMove = false
			end
		end
		if menuOffsetMoveD == 1 then
			menuXoffset = menuXoffset - 20
			if menuXoffset < 0 then
				menuXoffset = 0
				menuOffsetMoveD = 0
				menuOffsetMove = false
			end
		end
	end
end

function resetTileMap()

	tileMap = {}
	eventsMap = {}
	
	for y=1, map_height do
		local t = {}
		for x=1, map_width do
			table.insert(t,0)
		end
		table.insert(tileMap,t)
		table.insert(eventsMap,t)
	end
	
	collsMap = {}
	
	entityMap = {}
	
	events_table = {}
	
	mapLoadedID = nil
end

function love.mousepressed(x,y,button)
	system_messages.mousepressed(x,y)
	
	if #messages == 0 then
		
		if x > (maxW-60)-menuXoffset and x < (maxW-60)-menuXoffset + 50 and y > (maxH/2) - 10 and y < (maxH/2) + 10 then
			menuOffsetMove = true
		end
		
		if mainMode == 1 then
			for i=1, #tiles_spr do
				local Tx = 20
				local Ty = 90*(0.55*i)+36
				
				if x > Tx and x < Tx + tileSD and y > (Ty-tiles_SelectOffset)+(tiles_SelectOffset/10) and y < (Ty-tiles_SelectOffset)+(tiles_SelectOffset/10) + tileSD then
					tileSelected = i
					
					if drawMode == 0 then
						drawMode = 1
					end
				end
			end
		elseif mainMode == 2 then
			if drawMode == 1 then
				if x > tileS+gridOffsetX and x < tileS+gridOffsetX + map_width*tileS and y > tileS+gridOffsetY and y < tileS+gridOffsetY + map_height*tileS then
					collsX = x + camera.x
					collsY = y + camera.y
				end
			elseif drawMode == 0 then
				for i, v in ipairs(collsMap) do
					local x1 = false
					local y1 = false
					local w1 = false
					local h1 = false
				
					if v.w > 0 then
						if x + camera.x > v.x then
							x1 = true
						end
						if x + camera.x < v.x + v.w then
							w1 = true
						end
					elseif v.w < 0 then
						if x + camera.x < v.x then
							x1 = true
						end
						if x + camera.x > v.x + v.w then
							w1 = true
						end
					end
					if v.h > 0 then
						if y + camera.y > v.y then
							y1 = true
						end
						if y + camera.y < v.y + v.h then
							h1 = true
						end
					elseif v.h < 0 then
						if y + camera.y < v.y then
							y1 = true
						end
						if y + camera.y > v.y + v.h then
							h1 = true
						end
					end
					
					if x1 and w1 and y1 and h1 then
						table.remove(collsMap,i)
					end
				end
			end
		elseif mainMode == 3 then
			if entity_drawTYP == 1 then
				if drawMode == 1 then
					if x + camera.x > tileS+gridOffsetX and x + camera.x < tileS+gridOffsetX + map_width*tileS and y + camera.y > tileS+gridOffsetY and y + camera.y < tileS+gridOffsetY + map_height*tileS then
					
						if entity_drawID == 0 then
							newMessage("Enter Entity ID: <textBox(ID)>",3)
						end
					
						local t = {x=x+camera.x,y=y+camera.y,id=entity_drawID}
						table.insert(entityMap,t)
					end
				elseif drawMode == 0 then
					for i, v in ipairs(entityMap) do
						if x + camera.x > v.x and x + camera.x < v.x + 32 and y + camera.y > v.y and y + camera.y < v.y + 48 then
							table.remove(entityMap,i)
						end
					end
				end
			elseif entity_drawTYP == 2 then
				local mx, my = x, y
				
				for y1=1, #eventsMap do
					for x1=1, #eventsMap[y1] do
						local Tx = (x1 * tileS)
						local Ty = (y1 * tileS)
						
						if menuXoffset > 0 then
							if mx + camera.x > (maxW-60)-menuXoffset and mx + camera.x < (maxW-60)-menuXoffset + 300 and my + camera.y > 60 and my + camera.y < 60 + 480 then
								return
							end
						end
						
						if mx + camera.x > Tx and mx + camera.x < Tx + tileS and my + camera.y > Ty and my + camera.y < Ty + tileSD then
							if drawMode == 1 then
								newMessage("Enter room: <textBox(Room)>",4)
								eventsMap[y1][x1] = 1
								local t = {typ=1,x=x1,y=y1,room=0,goX=0,goY=0}
								table.insert(events_table,t)
							elseif drawMode == 0 then
								eventsMap[y1][x1] = 0
							end
						end
					end
				end
			end
		end
		
		if x > (maxW-50)-menuXoffset and x < (maxW-50)-menuXoffset + 40 and y > 80 and y < 80 + 40 then
			drawMode = 1
		end
		
		if x > (maxW-50)-menuXoffset and x < (maxW-50)-menuXoffset + 40 and y > 140 and y < 140 + 40 then
			drawMode = 0
		end
		
		if x > (maxW-50)-menuXoffset and x < (maxW-50)-menuXoffset + 40 and y > 350 and y < 350 + 40 then
			mainMode = 1
		end
		
		if x > (maxW-50)-menuXoffset and x < (maxW-50)-menuXoffset + 40 and y > 410 and y < 410 + 40 then
			mainMode = 2
		end
		
		if x > (maxW-50)-menuXoffset and x < (maxW-50)-menuXoffset + 40 and y > 470 and y < 470 + 40 then
			mainMode = 3
		end
		
		if x > (maxW+35)-menuXoffset and x < (maxW+35)-menuXoffset + 120 and y > 80 and y < 80 + 45 then
			newMessage("Insert map width and height: <textBox(width)> <textBox(height)>",1)
		end
		
		if x > (maxW+35)-menuXoffset and x < (maxW+35)-menuXoffset + 120 and y > 150 and y < 150 + 45 then
			exportMap()
		end
		
		if x > (maxW+35)-menuXoffset and x < (maxW+35)-menuXoffset + 120 and y > 220 and y < 220 + 45 then
			loadMap()
		end
		
		if x > (maxW+35)-menuXoffset and x < (maxW+35)-menuXoffset + 120 and y > 290 and y < 290 + 45 then
			if showGrid then
				showGrid = false
			else
				showGrid = true
			end
		end
		
		if x > (maxW+35)-menuXoffset and x < (maxW+35)-menuXoffset + 120 and y > 480 and y < 480 + 45 then
			resetTileMap()
			print("Map cleared")
		end
		
		if mainMode == 3 then
			if x > 15 and x < 15 + 32 and y > 85 and y < 85 + 32 then
				drawMode = 1
				entity_drawTYP = 1
				newMessage("Enter Entity ID: <textBox(ID)>",3)
			end
			
			if x > 15 and x < 15 + 32 and y > 135 and y < 135 + 32 then
				drawMode = 1
				entity_drawTYP = 2
			end
		end
	end
end

function love.keypressed(key)
	system_messages.keypressed(key)
	
	if key == "escape" then
		if #messages ~= 0 then
			table.remove(messages,1)
		end
		newMessage("Are you sure you wanna quit?",0,"HELL NO!!")
	end
	
	if #messages == 0 then
		if key == "1" then
			drawMode = 1
		end
		if key == "2" then
			drawMode = 0
		end
		if key == "3" then
			drawMode = 2
		end
		if key == "delete" then
			resetTileMap()
			print("Map cleared!")
		end
		if key == "e" then
			exportMap()
		end
		if key == "`" then
			if drawLines then
				drawLines = false
			else
				drawLines = true
			end
		end
		if mainMode == 1 then
			if key == "up" then
				if tilesDraw > 10 then
					tilesDraw = tilesDraw - 9
					tiles_SelectOffset = tiles_SelectOffset - 495
				end
			end
			if key == "down" then
				if tilesDraw < tiles_Num then
					tilesDraw = tilesDraw + 9
					tiles_SelectOffset = tiles_SelectOffset + 495
				end
			end
		end
		if key == "a" then
			loadMap()
		end
		if key == "m" then
			if mainMode == 1 then
				mainMode = 2
			elseif mainMode == 2 then
				mainMode = 3
			elseif mainMode == 3 then
				mainMode = 1
			end
		end
	end
end

function love.textinput(t)
	system_messages.textinput(t)
end