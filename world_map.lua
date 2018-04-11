require "maps_storage"

world_map = {}

function world_map.load()

	tile_spr_file = {
		love.graphics.newImage("/spr/tiles/tiles.png"),
	}

	local tile_calc = (tile_spr_file[1]:getWidth() / tileS) * (tile_spr_file[1]:getHeight() / tileS)
	
	local tilesNum = tile_calc + 1
	
	tile_spr = {}
	
	local x = 0
	local y = 0
	
	for i=1, tilesNum do
		local v = love.graphics.newQuad(x*tileS,y*tileS,tileS,tileS,tile_spr_file[1]:getWidth(),tile_spr_file[1]:getHeight())
		table.insert(tile_spr,v)
		
		x = x + 1
		
		if x * tileS > tile_spr_file[1]:getWidth() then
			y = y + 1
			x = 0
		end
	end

	maps_storage.load()
	
	map_data = {
		num = 1,
		colls = {},
	}
	
	local tileset = map_info[map_data.num].tileset

	gridOffsetX = ((maxW / 2) - ((#map_tiles[map_data.num][1] / 2)*tileS)) - tileS
	gridOffsetY = ((maxH / 2) - ((#map_tiles[map_data.num] / 2)*tileS)) - tileS
	
	world_map.update()
	
	room_change = false
	room_changeID = 0
	room_changeX = 0
	room_changeX = 0
end

function world_map.change(roomNUM,x,y)

	print("--ROOM CHANGED TO ROOM "..roomNUM.." X "..(x/32).." Y "..(y/32).." --")

	for i, coll in ipairs(map_data.colls) do
		world:remove(coll)
		map_data.colls[i] = nil
	end
	
	for i, v in ipairs(entities) do
		world:remove(v)
		entities[i] = nil
	end
	
	map_data.num = roomNUM
	
	gridOffsetX = ((maxW / 2) - ((#map_tiles[map_data.num][1] / 2)*tileS)) - tileS
	gridOffsetY = ((maxH / 2) - ((#map_tiles[map_data.num] / 2)*tileS)) - tileS
	
	if map_info[map_data.num].xLock == false then
		gridOffsetX = 0
	end
	
	if map_info[map_data.num].xLock == false then
		gridOffsetY = 0
	end
	
	world_map.update()
	
	for i=1, #map_entities do
		if i == roomNUM then
			for k, v in ipairs(map_entities[i]) do
				addEntity(v.id,v.x,v.y)
			end
		end
	end
	
	world:update(player, x,y)
	
	player.x = x
	player.y = y
	
	if map_info[map_data.num].xLock == false then
		if player.x - (maxW/2) < 32 then
			camera.x = 32
		else
			camera.x = (x - (maxW/2)) + player.w / 2
		end
	else
		camera.x = 0
	end
	
	if map_info[map_data.num].yLock == false then
		if ((player.y)+maxH/2)-(player.h/2) > (#map_tiles[map_data.num] * tileS) - (tileS / 2) then
			camera.y = ((#map_tiles[map_data.num] * tileS) - maxH) + tileS
		elseif (player.y-maxH/2)+(player.h/2) - player.spd < tileS then
			camera.y = tileS
		else
			camera.y = (y - (maxH/2)) + player.h / 2
		end
	else
		camera.y = 0
	end
	
	room_change = false
	room_changeID = 0
end

function world_map.update()
	for i, v in ipairs(map_colls[map_data.num]) do

		local x = v.x + gridOffsetX
		local y = v.y + gridOffsetY
		
		world_map.addColl(x,y,v.w,v.h)
	end
end

function world_map.addColl(x,y,w,h)
	local coll = {x=x,y=y,w=w,h=h}
	table.insert(map_data.colls,coll)
	world:add(coll,x,y,w,h)
end

function world_map.draw()
	local tileset = map_info[map_data.num].tileset
	
	for i=1, #map_tiles do
		if i == map_data.num then
			for y=1, #map_tiles[i] do
				for x=1, #map_tiles[i][y] do
					if map_tiles[i][y][x] ~= 0 then
						love.graphics.draw(tile_spr_file[tileset],tile_spr[map_tiles[i][y][x]],x*tileS+gridOffsetX,y*tileS+gridOffsetY)
					end
				end
			end
		end
	end
end