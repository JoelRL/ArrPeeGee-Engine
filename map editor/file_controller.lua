
function loadMap()
	if mapLoadID == nil then
		local files = love.filesystem.getDirectoryItems("/maps/")
	
		local list = ""
		
		for i, v in ipairs(files) do
			list = list .. v .. "\n"
		end
		
		list = list .. "<textBox(ID)>"
		
		newMessage(list,2)
	else
		-- START SETUP --
		
		local f = love.filesystem.newFile("/maps/map_"..mapLoadID..".txt")
	
		f:open("r")
		
		local text = f:read()
		
		f:close()
		
		-- END SETUP --
		
		-- START TILES LOAD --
		
		local start, enD = string.find(text,"tiles = {")
		
		local start1, end1 = string.find(text,"},ENDTILES.")
		
		local tilesLOAD = string.sub(text,enD+1,start1-1)
		
		local rows = {}
		
		string.gsub(tilesLOAD,"{(.-)}", function(a)  table.insert(rows,a) end )
		
		local nums = {}
		
		string.gsub(tilesLOAD,"(%d+)", function(a)  table.insert(nums,a) end )
		
		local pos = 1
		map_width = #nums/#rows
		map_height = #rows
		
		resetTileMap()
		
		tileMap = {}
		
		for y=1, map_height do
			local t = {}
			
			for x=1, map_width do
				table.insert(t,tonumber(nums[pos]))
				pos = pos + 1
			end
			
			table.insert(tileMap,t)
		end
		
		-- END TILES LOAD --
		
		if map_width * tileS > maxW - (tileS * 2) or map_height * tileS > maxH - (tileS * 2) then
			local num = (maxW - (map_width*tileS))-(maxH - (map_height*tileS))
			tileS = tileS - (num / 100)
		end
		
		gridOffsetX = ((maxW / 2) - ((map_width / 2)*tileS)) - tileS
		gridOffsetY = ((maxH / 2) - ((map_height / 2)*tileS)) - tileS
		
		-- START COLLS LOAD --
		
		collsMap = {}
		
		local start, enD = string.find(text,"colls = {")
		
		if start ~= nil then
		
			local start1, end1 = string.find(text,"},ENDCOLLS.")
			
			local collsLOAD = string.sub(text,enD+1,start1-1)
			
			local collsN = {}
			
			string.gsub(collsLOAD,"%-?%d+", function(a)  table.insert(collsN,a) end )
			
			local pos = 1
			
			local xs = {}
			local ys = {}
			local ws = {}
			local hs = {}
			
			for i=1, #collsN do
				if pos == 1 then
					local x = tonumber(collsN[i])
					table.insert(xs,x)
					pos = 2
				elseif pos == 2 then
					local y = tonumber(collsN[i])
					table.insert(ys,y)
					pos = 3
				elseif pos == 3 then
					table.insert(ws,tonumber(collsN[i]))
					pos = 4
				elseif pos == 4 then
					table.insert(hs,tonumber(collsN[i]))
					pos = 1
				end
			end
			
			for i=1, #collsN/4 do
				local var = (tileSD-tileS)/2
				if var == 0 then
					var = 1
				end
				local t = {x=xs[i],y=ys[i],w=ws[i],h=hs[i]}
				table.insert(collsMap,t)
			end
		end
		
		-- END COLLS LOAD --
		
		-- START ENTITIES LOAD --
		
		entityMap = {}
		
		local start, enD = string.find(text,"entities = {")
		
		if start ~= nil then
		
			local start1, end1 = string.find(text,"},ENDENTITY.")
			
			local entLOAD = string.sub(text,enD+1,start1-1)
			
			local entN = {}
			
			string.gsub(entLOAD,"%-?%d+", function(a)  table.insert(entN,a) end )
			
			local pos = 1
			
			local xs = {}
			local ys = {}
			local ws = {}
			local hs = {}
			local ids = {}
			
			for i=1, #entN do
				if pos == 1 then
					local x = tonumber(entN[i])
					table.insert(xs,x)
					pos = 2
				elseif pos == 2 then
					local y = tonumber(entN[i])
					table.insert(ys,y)
					pos = 3
				elseif pos == 3 then
					table.insert(ws,tonumber(entN[i]))
					pos = 4
				elseif pos == 4 then
					table.insert(hs,tonumber(entN[i]))
					pos = 5
				elseif pos == 5 then
					table.insert(ids,tonumber(entN[i]))
					pos = 1
				end
			end
			
			for i=1, #entN/5 do
				local t = {x=xs[i],y=ys[i],w=ws[i],h=hs[i],id=ids[i]}
				table.insert(entityMap,t)
			end
		end
		
		-- END ENTITIES LOAD --
		
		-- START EVENTS LOAD --
		
		events_table = {}
		
		local start, enD = string.find(text,"events = {")
		
		if start ~= nil then
		
			local start1, end1 = string.find(text,"},ENDEVENTS.")
			
			local eventLOAD = string.sub(text,enD+1,start1-1)
			
			local eventN = {}
			
			string.gsub(eventLOAD,"%-?%d+", function(a)  table.insert(eventN,a) end )
			
			local pos = 1
			local typLoop = 0
			local done = false
			
			local eventsTable = {}
			
			for i=1, #eventN do
				done = false
				if pos == 1 and done == false then
					local newTable = {}
					
					table.insert(eventsTable,newTable)
					
					local typ = tonumber(eventN[i])
					table.insert(eventsTable[#eventsTable],typ)
						
					typLoop = typ
						
					pos = 2
						
					done = true
				elseif pos == 2 and done == false then
					local x = tonumber(eventN[i])
					table.insert(eventsTable[#eventsTable],x)
					pos = 3
					done = true
				elseif pos == 3 and done == false then
					local y = tonumber(eventN[i])
					table.insert(eventsTable[#eventsTable],y)
					pos = 4
					done = true
				end
				if typLoop == 1 then
					if pos == 4 and done == false then
						local room = tonumber(eventN[i])
						table.insert(eventsTable[#eventsTable],room)
						pos = 5
						done = true
					end
					if pos == 5 and done == false then
						local goX = tonumber(eventN[i])
						table.insert(eventsTable[#eventsTable],goX)
						pos = 6
						done = true
					end
					if pos == 6 and done == false then
						local goY = tonumber(eventN[i])
						table.insert(eventsTable[#eventsTable],goY)
						pos = 1
						done = true
					end
				end
			end
			
			
			for i=1, #eventsTable do
				if eventsTable[i][1] == 1 then
					local t = {typ=eventsTable[i][1],x=eventsTable[i][2],y=eventsTable[i][3],room=eventsTable[i][4],goX=eventsTable[i][5],goY=eventsTable[i][6]}
					table.insert(events_table,t)
				end
				eventsMap[eventsTable[i][3]][eventsTable[i][2]] = 1
			end
		end
		
		-- END EVENTS LOAD --
		
		local start, end1 = string.find(text,"TILESET = ")
		
		if start ~= nil then
		
			local start2, end2 = string.find(text,",ENDTILESET.")
		
			local tileSETN = string.sub(text,end1+1,start2-1)
			
			local t = {tileset=tonumber(tileSETN)}
		else
			local t = {tileset=1}
		end
		
		mapLoadedID = mapLoadID
		mapLoadID = nil
	end
end

function exportMap()
	local mapTable = "tiles = {\r\n"
	
	for y=1, #tileMap do
		for x=1, #tileMap[y] do
			if x == 1 then
				mapTable = mapTable .. "	{"
			end
			
			local str = tostring(tileMap[y][x])
			
			mapTable = mapTable .. str .. ","
			
			if x == #tileMap[y] then
				mapTable = mapTable .. "},\r\n"
			end
		end
	end
	
	mapTable = mapTable .. "},ENDTILES.\r\n\r\ncolls = {\r\n"
	
	for i, v in ipairs(collsMap) do
		mapTable = mapTable .. "	{x="..math.floor(v.x)..",y="..math.floor(v.y)..",w="..math.floor(v.w)..",h="..math.floor(v.h).."},\r\n"
	end
	
	mapTable = mapTable .. "},ENDCOLLS.\r\n\r\nentities = {\r\n"
	
	for i, v in ipairs(entityMap) do
		mapTable = mapTable .. "	{x="..math.floor(v.x)..",y="..math.floor(v.y)..",w=32,h=48,id="..v.id.."},\r\n"
	end
	
	mapTable = mapTable .. "},ENDENTITY.\r\n\r\nevents = {\r\n"
	
	for i, v in ipairs(events_table) do
		if v.typ == 1 then
			mapTable = mapTable .. "	{typ="..v.typ..",x="..v.x..",y="..v.y..",room="..v.room..",goX="..v.goX..",goY="..v.goY.."},\r\n"
		end
	end
	
	mapTable = mapTable .. "},ENDEVENTS."
	
	local files = love.filesystem.getDirectoryItems("/maps/")

	local mapsNum = #files + 1
	
	if not love.filesystem.exists("data") then
		success = love.filesystem.createDirectory("data")
		if success then
			print("Directory creation successfull")
		else
			print("Directory creation failed")
		end
	else
		print("YEP")
	end
	
	if not love.filesystem.exists("maps") then
		success = love.filesystem.createDirectory("maps")
		if success then
			print("Directory creation successfull")
		else
			print("Directory creation failed")
		end
	else
		print("YEP")
	end
	
	if mapLoadedID == nil then
		f = love.filesystem.newFile("/maps/map_"..mapsNum..".txt")
	else
		f = love.filesystem.newFile("/maps/map_"..mapLoadedID..".txt")
	end
	
	mapLoadedID = mapsNum
	
	f:open("w")
	
	f:write(mapTable)
	
	local tileSET = "\r\n\r\nTILESET = 1 ,ENDTILESET."
		
	f:write(tileSET)
	
	f:flush()
	
	f:close()
	
	newMessage("Save directory is "..dir,0)
end