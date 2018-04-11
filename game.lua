game = {}

function game.load()

	tileS = 32
	world = bump.newWorld(tileS)
	npcActing = false
	world_messages = {}
	stopActing = false
	
	player = {
		typ = "player",
		x = 400,
		y = 400,
		w = 32,
		h = 48,
		spd = 2,
		gR = false,
		gL = false,
		gU = false,
		gD = false,
		lastD = "",
		spr = 2,
		sprTimr = 0,
		sprSpd = 10,
		frame = 1,
		spriteSheet = 1,
		spriteOffsetX = 0,
		spriteOffsetY = 0,
		spriteScale = 1,
		touchNPC = false,
		npcID = 0,
		NPCpointer1 = 0,
		move = true,
		stopX = false,
		stopY = false,
	}
	
	world:add(player,player.x,player.y,player.w,player.h)
	
	showColls = false
	
	cameraX1 = true
	cameraX2 = true
	cameraY1 = true
	cameraY2 = true
end

function game.draw()
	world_map.draw()
	if showColls then
		drawBox(player,200,50,50)
		for i, v in ipairs(map_colls[map_data.num]) do
			local t = {x=v.x+gridOffsetX,y=v.y+gridOffsetY,w=v.w,h=v.h}
			drawBlock(t,252,252,252)
		end
		for i, b in ipairs(map_events) do
			if i == map_data.num then
				for k, v in ipairs(map_events[i]) do
					local t = {x=v.x*tileS+gridOffsetX,y=v.y*tileS+gridOffsetY,w=32,h=32}
					drawBlock(t,252,0,0)
				end
			end
		end
	end
	draw_sprite(player)
end

function game.update(dt)

	player_update()
	
	if room_change then
		world_map.change(room_changeID,room_changeX*tileS+gridOffsetX,room_changeY*tileS+gridOffsetY)
	end
end

function player_update()

	if map_info[map_data.num].yLock == false then
		local dist = ((player.y+player.h)+maxH/2)-(player.h/2)
		
		local north = (#map_tiles[map_data.num] * tileS) + player.spd

		if ((player.y)+maxH/2)-(player.h/2) > north or player.y - (maxH/2) < tileS then
			cameraY1 = false
			cameraY2 = false
			if ((player.y)+maxH/2)-(player.h/2) > (#map_tiles[map_data.num] * tileS) + player.spd then
				camera.y = ((#map_tiles[map_data.num] * tileS) - maxH) + tileS
			end
			if player.y - (maxH/2) < tileS then
				camera.y = tileS
			end
		else
			cameraY1 = true
			cameraY2 = true
		end
	end
	
	if map_info[map_data.num].xLock == false then
		if (player.x - (maxW/2)) - player.spd < 32 or (player.x + player.w) + (maxW/2) > (#map_tiles[map_data.num][1] * tileS) + (tileS * 2) then
			cameraX1 = false
			cameraX2 = false
			if (player.x - (maxW/2)) - player.spd < 32 then
				camera.x = 32
			end
			if (player.x + player.w) + (maxW/2) > (#map_tiles[map_data.num][1] * tileS) + (tileS * 2) then
				camera.x = ((#map_tiles[map_data.num][1] * tileS) + tileS) - maxW
			end
		else
			cameraX1 = true
			cameraX2 = true
		end
	end

	if player.move then
		player_move()
	end
	
	if player.touchNPC then
		if npcActing == false and love.keyboard.isDown("z") then
			npcActing = true
			for i, v in ipairs(entities) do
				if v.typ == "npc" then
					if v.id == player.npcID then
						player.move = false
						npcAction(v.id)
					end
				end
			end
		end
	end
	
	for i, b in ipairs(map_events) do
		if i == map_data.num then
			for k, v in ipairs(map_events[i]) do
				local t1 = {x=player.x,y=player.y,w=player.w,h=player.h}
				local t2 = {x=v.x*tileS+gridOffsetX,y=v.y*tileS+gridOffsetY,w=32,h=32}
				if checkCollision(t1,t2) then
					if v.typ == 1 then
						room_change = true
						room_changeID = v.room
						room_changeX = v.goX
						room_changeY = v.goY
					end
				end
			end
		end
	end
end

function player_move()
	local dx = 0
	local dy = 0
	local speed = player.spd
	player.gR = false
	player.gL = false
	player.gU = false
	player.gD = false
	
	if love.keyboard.isDown("up") then
		dy = dy - speed
		player.gU = true
		player.gD = false
		player.lastD = "U"
		if map_info[map_data.num].yLock == false and player.stopY == false and cameraY1 then
			camera.y = camera.y - speed
		end
	elseif love.keyboard.isDown("down") then
		dy = dy + speed
		player.gD = true
		player.gU = false
		player.lastD = "D"
		if map_info[map_data.num].yLock == false and player.stopY == false and cameraY2 then
			camera.y = camera.y + speed
		end
	else
		if player.lastD == "U" then
			player.spr = 2
		elseif player.lastD == "D" then
			player.spr = 1
		end
	end
	
	if love.keyboard.isDown("right") then
		dx = dx + speed
		player.gR = true
		player.gL = false
		player.lastD = "R"
		if map_info[map_data.num].xLock == false and player.stopX == false and cameraX1 then
			camera.x = camera.x + speed
		end
	elseif love.keyboard.isDown("left") then
		dx = dx - speed
		player.gL = true
		player.gR = false
		player.lastD = "L"
		if map_info[map_data.num].xLock == false and player.stopX == false and cameraX2 then
			camera.x = camera.x - speed
		end
	else
		if player.lastD == "R" then
			player.spr = 3
		elseif player.lastD == "L" then
			player.spr = 4
		end
	end
	
	if dx ~= 0 or dy ~= 0 then
		
		local px, py, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
		
		for i, v in ipairs(cols) do
			if v.other.typ == "npc" then
				player.touchNPC = true
				player.npcID = v.other.id
				player.NPCpointer1 = v.other.actingID
			else
				player.touchNPC = false
				player.npcID = 0
				player.NPCpointer1 = 0
			end
		end
		
		if #cols == 0 then
			player.touchNPC = false
			player.npcID = 0
			if player.stopX then
				player.stopX = false
			end
			if player.stopY then
				player.stopY = false
			end
		else
			if player.x - px == 0 then
				player.stopX = true
			else
				player.stopX = false
			end
			if player.y - py == 0 then
				player.stopY = true
			else
				player.stopY = false
			end
		end
		
		player.x = px
		player.y = py
	end
	
	player_checkDir()
	player_anim()
end

function player_anim()

	player.sprTimr = player.sprTimr + 1

	if player.spriteOffsetX ~= 0 then
		player.spriteOffsetX = 0
	end
	if player.spriteOffsetY ~= 0 then
		player.spriteOffsetY = 0
	end
	if player.spriteScale ~= 1 then
		player.spriteScale = 1
	end
	
	if player.spr == 1 then
		player.frame = 1
		player.sprTimr = 0
	end
	if player.spr == 2 then
		player.frame = 3
		player.sprTimr = 0
	end
	if player.spr == 3 then
		player.frame = 5
		player.spriteScale = -1
		player.spriteOffsetX = player.w
		player.sprTimr = 0
	end
	if player.spr == 4 then
		player.frame = 5
		player.sprTimr = 0
	end
	if player.spr == 5 then
		if player.sprTimr > player.sprSpd then
			if player.frame == 1 then
				player.frame = 2
			else
				player.frame = 1
			end
			
			player.sprTimr = 0
		end
	end
	if player.spr == 6 then
		if player.sprTimr > player.sprSpd then
			if player.frame == 3 then
				player.frame = 4
			else
				player.frame = 3
			end
			
			player.sprTimr = 0
		end
	end
	if player.spr == 7 then
		if player.sprTimr > player.sprSpd then
			if player.frame == 5 then
				player.frame = 6
			else
				player.frame = 5
			end
			
			player.sprTimr = 0
		end
	end
	if player.spr == 8 then
		player.spriteScale = -1
		player.spriteOffsetX = player.w
		if player.sprTimr > player.sprSpd then
			if player.frame == 5 then
				player.frame = 6
			else
				player.frame = 5
			end
			
			player.sprTimr = 0
		end
	end
	if player.spr == 9 then
		if player.sprTimr > player.sprSpd then
			if player.frame == 7 then
				player.frame = 8
			else
				player.frame = 7
			end
			
			player.sprTimr = 0
		end
	end
	if player.spr == 10 then
		if player.sprTimr > player.sprSpd then
			if player.frame == 9 then
				player.frame = 10
			else
				player.frame = 9
			end
			
			player.sprTimr = 0
		end
	end
	if player.spr == 11 then
		player.spriteScale = -1
		player.spriteOffsetX = player.w
		if player.sprTimr > player.sprSpd then
			if player.frame == 7 then
				player.frame = 8
			else
				player.frame = 7
			end
			
			player.sprTimr = 0
		end
	end
	if player.spr == 12 then
		player.spriteScale = -1
		player.spriteOffsetX = player.w
		if player.sprTimr > player.sprSpd then
			if player.frame == 9 then
				player.frame = 10
			else
				player.frame = 9
			end
			
			player.sprTimr = 0
		end
	end
end

function player_checkDir()
	if player.gR and not player.gL and not player.gU and not player.gD then
		--print("RIGHT")
		player.spr = 8
	elseif player.gL and not player.gR and not player.gU and not player.gD then
		--print("LEFT")
		player.spr = 7
	elseif player.gU and not player.gD and not player.gR and not player.gL then
		--print("UP")
		player.spr = 6
	elseif player.gD and not player.gU and not player.gR and not player.gL then
		--print("DOWN")
		player.spr = 5
	elseif player.gU and player.gR and not player.gD and not player.gL then
		--print("UP AND RIGHT")
		player.spr = 12
	elseif player.gD and player.gR and not player.gU and not player.gL then
		--print("DOWN AND RIGHT")
		player.spr = 11
	elseif player.gU and player.gL and not player.gD and not player.gR then
		--print("UP AND LEFT")
		player.spr = 10
	elseif player.gD and player.gL and not player.gU and not player.gR then
		--print("DOWN AND LEFT")
		player.spr = 9
	end
end

function checkCollision(a, b)
    --With locals it's common usage to use underscores instead of camelCasing
    local a_left = a.x
    local a_right = a.x + a.w
    local a_top = a.y
    local a_bottom = a.y + a.h

    local b_left = b.x
    local b_right = b.x + b.w
    local b_top = b.y
    local b_bottom = b.y + b.h

    --If Red's right side is further to the right than Blue's left side.
    if a_right > b_left and
    --and Red's left side is further to the left than Blue's right side.
    a_left < b_right and
    --and Red's bottom side is further to the bottom than Blue's top side.
    a_bottom > b_top and
    --and Red's top side is further to the top than Blue's bottom side then..
    a_top < b_bottom then
        --There is collision!
        return true
    else
        --If one of these statements is false, return false.
        return false
    end
end