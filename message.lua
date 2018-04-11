require "script"

message = {}

function newMessage(pointer1)
	local t = {}
	
	t.pointer1 = pointer1
	
	table.insert(world_messages,t)
end

function message.load()
	text = {
		num = 1,
		textBoxX = maxW/2-(300/2),
		textBoxY = 10,
		textBoxW = 300,
		textBoxH = 80,
		textOffX = 10,
		textOffY = 10,
		defSpd = 0.01,
	}
	
	drawMessage = true
	
	message.resetVar()
end

function message.resetVar()

	text.done = false

	text.printedText  = ""

	text.typeTimerMax = text.defSpd
	text.typeTimer 	 = text.defSpd

	text.typePosition = 0
end

function message.close()
	text.num = 1
	npcActing = false
	player.move = true
	player.touchNPC = false
		
	for i, v in ipairs(entities) do
		if v.typ == "npc" then
			if v.id == player.npcID then
				if v.locked then
					v.frame = v.defFrame
				end
			end
		end
	end
				
	player.npcID = 0
	table.remove(world_messages,1)
	message.resetVar()
end

function messageAction(txt,pointer1)

	drawMessage = false

	if string.find(txt,"<frameChng") then
		local parameters = txt:match("%((.-)%)")
		
		for i, v in ipairs(entities) do
			if v.typ == "npc" then
				if v.id == player.npcID then
					v.frame = tonumber(parameters)
					entity_storage_values[v.id].frame = tonumber(parameters)
				end
			end
		end
	end
	
	if string.find(txt,"<sprChng") then
		local parameters = txt:match("%((.-)%)")
		
		for i, v in ipairs(entities) do
			if v.typ == "npc" then
				if v.id == player.npcID then
					v.spr = tonumber(parameters)
				end
			end
		end
	end
	
	if string.find(txt,"<move") then
		local parameters = txt:match("%((.-)%)")
		local output = {}
		
		for match in parameters:gmatch("%-?%d+") do
			func = assert(load("return " .. match))
			output[#output + 1] = func()
		end
		
		for i, v in ipairs(entities) do
			if v.typ == "npc" then
				if v.id == player.npcID then
					v.move = true
					v.moveDist = output[2]
					v.moveDir = output[1]
					v.moveSpd = output[3]
					if output[4] == 1 then
						stopActing = true
						drawMessage = false
						print("DOME")
					end
					v.moveX = v.x
					v.moveY = v.y
				end
			end
		end
	end
	
	if string.find(txt,"<removeSelf>") then
		for i, v in ipairs(entities) do
			if v.typ == "npc" then
				if v.id == player.npcID then
					world:remove(v)
					table.remove(entities,i)
				end
			end
		end
	end
	
	if string.find(txt,"<pointerChng") then
		local point = {}
		
		string.gsub(txt,"(%d+)", function(a)  table.insert(point,a) end )
		
		for i, v in ipairs(entities) do
			if v.typ == "npc" then
				if v.id == player.npcID then
					v.actingID = tonumber(point[1])
					entity_storage_values[v.entityID].actingID = v.actingID
				end
			end
		end
	end
	
	drawMessage = true
	
	if script_storage[pointer1][text.num+1] == nil then
		message.close()
	else
		text.num = text.num + 1
		message.resetVar()
	end
end

function message.update(dt,message)
	if text.typePosition <= string.len(message) then
		text.typeTimer = text.typeTimer - dt

		if text.typeTimer <= 0 then
			text.typeTimer = text.defSpd
			text.typePosition = text.typePosition + 1
			text.printedText = string.sub(message,0,text.typePosition)
		end
	end
	if text.typePosition >= string.len(message) then
		text.done = true
	end
end

function message.draw()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",text.textBoxX,text.textBoxY,text.textBoxW,text.textBoxH)
	love.graphics.setColor(252,252,252)
	love.graphics.rectangle("line",text.textBoxX,text.textBoxY,text.textBoxW,text.textBoxH)
	love.graphics.printf(text.printedText,text.textBoxX+text.textOffX,text.textBoxY+text.textOffY,text.textBoxW-text.textOffX,"left")
end