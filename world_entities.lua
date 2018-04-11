require "entity_storage"
entity_storage.load()
	
world_entities = {}

function world_entities.load()
	entities = {}
	
	for i=1, #map_entities do
		if i == map_data.num then
			for k, v in ipairs(map_entities[i]) do
				addEntity(v.id,v.x,v.y)
			end
		end
	end
end

function addEntity(id,x,y)
	local t = {}
	
	t.id = #entities + 1
	
	if entity_storage_values[id].x == nil then
		t.x = x + gridOffsetX
	else
		t.x = entity_storage_values[id].x
	end
	
	if entity_storage_values[id].y == nil then
		t.y = y + gridOffsetY
	else
		t.y = entity_storage_values[id].y
	end
	
	t.w = 32
	t.h = 48
	t.sprTimr = 0
	t.sprSpd = 10
	t.spriteOffsetX = 0
	t.spriteOffsetY = 0
	t.spriteScale = 1
	t.move = false
	t.moveDist = 0
	t.moveDir = 0
	t.moveSpd = 0
	t.moveX = 0
	t.moveY = 0
	t.entityID = id
	
	-- local vars = checkSpecialVars(id)
	
	t.typ = entity_storage_values[id].typ
	t.spr = entity_storage_values[id].spr
	t.spriteSheet = entity_storage_values[id].spriteSheet
	t.actingID = entity_storage_values[id].actingID
	t.locked = entity_storage_values[id].locked
	t.frame = entity_storage_values[id].frame
	t.defFrame = entity_storage_values[id].frame
	
	if t.frame == 4 then
		t.spriteScale = -1
		t.spriteOffsetX = t.w
	end
	
	world:add(t,t.x,t.y,t.w,t.h)
	
	table.insert(entities,t)
end

function world_entities.draw()
	for i, v in ipairs(entities) do
		draw_sprite(v)
		if showColls then
			drawBox(v,200,50,50)
			love.graphics.print("Point "..v.actingID,v.x+20,v.y)
		end
		
		if v.move then
			if v.moveDist > 0 then
				if v.moveDir == 1 then
					if v.x < v.moveX + v.moveDist then
						v.x = v.x + v.moveSpd
						
						local cols = {}
						v.x, v.y, cols, cols_len = world:move(v, v.x, v.y)
						
						if #cols > 0 then
							v.move = false
							stopActing = false
							drawMessage = true
							v.move = false
							entity_storage_values[v.entityID].x = v.x
							entity_storage_values[v.entityID].y = v.y
						end
					else
						stopActing = false
						drawMessage = true
						v.move = false
						entity_storage_values[v.entityID].x = v.x
						entity_storage_values[v.entityID].y = v.y
					end
				elseif v.moveDir == 2 then
					if v.y < v.moveY + v.moveDist then
						v.y = v.y + v.moveSpd
						
						local cols = {}
						v.x, v.y, cols, cols_len = world:move(v, v.x, v.y)
						
						if #cols > 0 then
							v.move = false
							stopActing = false
							drawMessage = true
							v.move = false
							entity_storage_values[v.entityID].x = v.x
							entity_storage_values[v.entityID].y = v.y
						end
					else
						stopActing = false
						drawMessage = true
						v.move = false
						entity_storage_values[v.entityID].x = v.x
						entity_storage_values[v.entityID].y = v.y
					end
				elseif v.moveDir == 3 then
					if player.lastD == "R" then
						if v.x < v.moveX + v.moveDist then
							v.x = v.x + v.moveSpd
							
							local cols = {}
							v.x, v.y, cols, cols_len = world:move(v, v.x, v.y)
							
							if #cols > 0 then
								v.move = false
								stopActing = false
								drawMessage = true
								v.move = false
								entity_storage_values[v.entityID].x = v.x
								entity_storage_values[v.entityID].y = v.y
							end
						else
							stopActing = false
							drawMessage = true
							v.move = false
							entity_storage_values[v.entityID].x = v.x
							entity_storage_values[v.entityID].y = v.y
						end
					elseif player.lastD == "L" then
						if v.x > v.moveX - v.moveDist then
							v.x = v.x - v.moveSpd
							
							local cols = {}
							v.x, v.y, cols, cols_len = world:move(v, v.x, v.y)
							
							if #cols > 0 then
								v.move = false
								stopActing = false
								drawMessage = true
								v.move = false
								entity_storage_values[v.entityID].x = v.x
								entity_storage_values[v.entityID].y = v.y
							end
						else
							stopActing = false
							drawMessage = true
							v.move = false
							entity_storage_values[v.entityID].x = v.x
							entity_storage_values[v.entityID].y = v.y
						end
					elseif player.lastD == "U" then
						if v.y > v.moveY - v.moveDist then
							v.y = v.y - v.moveSpd
							
							local cols = {}
							v.x, v.y, cols, cols_len = world:move(v, v.x, v.y)
							
							if #cols > 0 then
								v.move = false
								stopActing = false
								drawMessage = true
								v.move = false
								entity_storage_values[v.entityID].x = v.x
								entity_storage_values[v.entityID].y = v.y
							end
						else
							stopActing = false
							drawMessage = true
							v.move = false
							entity_storage_values[v.entityID].x = v.x
							entity_storage_values[v.entityID].y = v.y
						end
					elseif player.lastD == "D" then
						if v.y < v.moveY + v.moveDist then
							v.y = v.y + v.moveSpd
							
							local cols = {}
							v.x, v.y, cols, cols_len = world:move(v, v.x, v.y)
							
							if #cols > 0 then
								v.move = false
								stopActing = false
								drawMessage = true
								v.move = false
								entity_storage_values[v.entityID].x = v.x
								entity_storage_values[v.entityID].y = v.y
							end
						else
							stopActing = false
							drawMessage = true
							v.move = false
							entity_storage_values[v.entityID].x = v.x
							entity_storage_values[v.entityID].y = v.y
						end
					end
				end
			else
				if v.moveDir == 1 then
					if v.x > v.moveX + v.moveDist then
						v.x = v.x - v.moveSpd
						
						local cols = {}
						v.x, v.y, cols, cols_len = world:move(v, v.x, v.y)
						
						if #cols > 0 then
							v.move = false
							stopActing = false
							drawMessage = true
							v.move = false
							entity_storage_values[v.entityID].x = v.x
							entity_storage_values[v.entityID].y = v.y
						end
					else
						stopActing = false
						drawMessage = true
						v.move = false
						entity_storage_values[v.entityID].x = v.x
						entity_storage_values[v.entityID].y = v.y
					end
				elseif v.moveDir == 2 then
					if v.y > v.moveY + v.moveDist then
						v.y = v.y - v.moveSpd
						
						local cols = {}
						v.x, v.y, cols, cols_len = world:move(v, v.x, v.y)
						
						if #cols > 0 then
							v.move = false
							stopActing = false
							drawMessage = true
							v.move = false
							entity_storage_values[v.entityID].x = v.x
							entity_storage_values[v.entityID].y = v.y
						end
					else
						stopActing = false
						drawMessage = true
						v.move = false
						entity_storage_values[v.entityID].x = v.x
						entity_storage_values[v.entityID].y = v.y
					end
				end
			end
		end
	end
end

function npcAction(id)
	for i, v in ipairs(entities) do
		if v.id == id then
			if v.spriteOffsetX ~= 0 then
				v.spriteOffsetX = 0
			end
			if v.spriteOffsetY ~= 0 then
				v.spriteOffsetY = 0
			end
			if v.spriteScale ~= 1 then
				v.spriteScale = 1
			end
								
			if player.lastD == "U" then
				v.frame = 1
			elseif player.lastD == "D" then
				v.frame = 2
			elseif player.lastD == "L" then
				v.frame = 3
				v.spriteScale = -1
				v.spriteOffsetX = v.w
			elseif player.lastD == "R" then
				v.frame = 4
			end
			
			newMessage(v.actingID)
		end
	end
end

function checkSpecialVars(id)
	if id == 1 then
		local t = {}
		t.typ = "npc"
		t.spr = 2
		t.spriteSheet = 2
		t.actingID = 1
		t.locked = true
		t.frame = 1
		return t
	end
	if id == 2 then
		local t = {}
		t.typ = "npc"
		t.spr = 3
		t.spriteSheet = 2
		t.actingID = 2
		t.locked = true
		t.frame = 1
		return t
	end
	if id == 3 then
		local t = {}
		t.typ = "npc"
		t.spr = 4
		t.spriteSheet = 2
		t.actingID = 4
		t.locked = false
		t.frame = 4
		return t
	end
	if id == 4 then
		local t = {}
		t.typ = "npc"
		t.spr = 6
		t.spriteSheet = 2
		t.actingID = 5
		t.locked = true
		t.frame = 3
		return t
	end
end