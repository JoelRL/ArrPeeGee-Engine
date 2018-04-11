maps_storage = {}

function maps_storage.load()

	map_info = {}

	map_colls = {}
	
	map_tiles = {}
	
	map_entities = {}
	
	map_events = {}
	
	local files = love.filesystem.getDirectoryItems("/maps/")
	
	for i=1, #files do
	
		local f = love.filesystem.newFile("/maps/map_"..i..".txt")
	
		f:open("r")
		
		local text = f:read()
		
		f:close()
		
		local start, enD = string.find(text,"tiles = {")
		
		local start1, end1 = string.find(text,"},ENDTILES.")
		
		local tilesLOAD = string.sub(text,enD+1,start1-1)
		
		local rows = {}
		
		string.gsub(tilesLOAD,"{(.-)}", function(a)  table.insert(rows,a) end )
		
		local nums = {}
		
		string.gsub(tilesLOAD,"(%d+)", function(a)  table.insert(nums,a) end )
		
		local pos = 1
		
		tileMap = {}
		
		local newTable = {}
		
		table.insert(map_tiles,newTable)
		
		for y=1, #rows do
			local t = {}
			
			for x=1, #nums/#rows do
				table.insert(t,tonumber(nums[pos]))
				pos = pos + 1
			end
			
			table.insert(map_tiles[#map_tiles],t)
		end
		
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
			
			for c1=1, #collsN do
				if pos == 1 then
					local x = tonumber(collsN[c1])
					table.insert(xs,x)
					pos = 2
				elseif pos == 2 then
					local y = tonumber(collsN[c1])
					table.insert(ys,y)
					pos = 3
				elseif pos == 3 then
					if tonumber(collsN[c1]) > 0 then
						table.insert(ws,tonumber(collsN[c1]))
						pos = 4
					else
						xs[#xs] = xs[#xs] + tonumber(collsN[c1])
						
						local width = tonumber(collsN[c1]) * -1
						
						table.insert(ws,width)
						pos = 4
					end
				elseif pos == 4 then
					if tonumber(collsN[c1]) > 0 then
						table.insert(hs,tonumber(collsN[c1]))
						pos = 1
					else
						ys[#ys] = ys[#ys] + tonumber(collsN[c1])
						
						local height = tonumber(collsN[c1]) * -1
						
						table.insert(hs,height)
						
						pos = 1
					end
				end
			end
			
			local newTable = {}
			
			table.insert(map_colls,newTable)
			
			for c2=1, #collsN/4 do
				local t = {x=xs[c2],y=ys[c2],w=ws[c2],h=hs[c2]}
				table.insert(map_colls[#map_colls],t)
			end
		end
		
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
			
			for e=1, #entN do
				if pos == 1 then
					local x = tonumber(entN[e])
					table.insert(xs,x)
					pos = 2
				elseif pos == 2 then
					local y = tonumber(entN[e])
					table.insert(ys,y)
					pos = 3
				elseif pos == 3 then
					table.insert(ws,tonumber(entN[e]))
					-- -- print("MAP #"..i.." W IS "..entN[e])
					pos = 4
				elseif pos == 4 then
					table.insert(hs,tonumber(entN[e]))
					-- -- print("MAP #"..i.." H IS "..entN[e])
					pos = 5
				elseif pos == 5 then
					-- -- print("MAP #"..i.." ID IS "..entN[e])
					table.insert(ids,tonumber(entN[e]))
					pos = 1
				end
			end
			
			local newTable = {}
			
			table.insert(map_entities,newTable)
			
			for e1=1, #entN/5 do
				local t = {x=xs[e1],y=ys[e1],w=ws[e1],h=hs[e1],id=ids[e1]}
				table.insert(map_entities[#map_entities],t)
			end
		end
		
		local newTable = {}
		
		table.insert(map_events,newTable)
		
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
			
			for ev1=1, #eventN do
				done = false
				if pos == 1 and done == false then
					local newTable = {}
					
					table.insert(eventsTable,newTable)
					
					local typ = tonumber(eventN[ev1])
					table.insert(eventsTable[#eventsTable],typ)
						
					typLoop = typ
						
					pos = 2
						
					done = true
				elseif pos == 2 and done == false then
					local x = tonumber(eventN[ev1])
					table.insert(eventsTable[#eventsTable],x)
					pos = 3
					done = true
				elseif pos == 3 and done == false then
					local y = tonumber(eventN[ev1])
					table.insert(eventsTable[#eventsTable],y)
					pos = 4
					done = true
				end
				if typLoop == 1 then
					if pos == 4 and done == false then
						local room = tonumber(eventN[ev1])
						table.insert(eventsTable[#eventsTable],room)
						pos = 5
						done = true
					end
					if pos == 5 and done == false then
						local goX = tonumber(eventN[ev1])
						table.insert(eventsTable[#eventsTable],goX)
						pos = 6
						done = true
					end
					if pos == 6 and done == false then
						local goY = tonumber(eventN[ev1])
						table.insert(eventsTable[#eventsTable],goY)
						pos = 1
						done = true
					end
				end
			end
			
			
			for ev2=1, #eventsTable do
				if eventsTable[ev2][1] == 1 then
					local t = {typ=eventsTable[ev2][1],x=eventsTable[ev2][2],y=eventsTable[ev2][3],room=eventsTable[ev2][4],goX=eventsTable[ev2][5],goY=eventsTable[ev2][6]}
					table.insert(map_events[#map_events],t)
				end
			end
		end
		
		local start, end1 = string.find(text,"TILESET = ")
		
		if start ~= nil then
		
			local start2, end2 = string.find(text,",ENDTILESET.")
		
			local tileSETN = string.sub(text,end1+1,start2-1)
			
			local rowsN = #rows * tileS
			local colsN = (#nums/#rows) * tileS
			local xLock = true
			local yLock = true
			
			-- print("MAP #"..i.."ROWS IS "..rowsN.." COLS IS "..colsN)
			
			if rowsN > (maxW / 2) + 100 then
				-- print("HA")
				xLock = false
			end
			
			if colsN > maxH then
				yLock = false
			end
			
			local t = {tileset=tonumber(tileSETN),xLock=xLock,yLock=yLock}
			
			table.insert(map_info,t)
		else
			local t = {tileset=1}
			
			table.insert(map_info,t)
		end
		
	end
	
end





















