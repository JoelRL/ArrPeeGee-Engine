local utf8 = require("utf8")
system_messages = {}

function system_messages.load()
	
	messages = {}
	
	messagesID = 0
	
	textBoxFont = love.graphics.newFont(30)
	
	normalFont = love.graphics.newFont()
	
	textFont = love.graphics.newFont(25)
end

function system_messages.draw()
	for i, v in ipairs(messages) do
		
		love.graphics.setColor(30,30,30)
		
		love.graphics.rectangle("fill",v.x,v.y,v.w,v.h,5,5)
		
		love.graphics.setColor(252,252,252)
		
		love.graphics.rectangle("line",v.x,v.y,v.w,v.h,5,5)
		
		love.graphics.setFont(textFont)
		
		love.graphics.printf(v.text,v.x,v.y+12,v.w,"center")
	
		for k, b in ipairs(v.textBoxes) do
			love.graphics.setColor(50,50,50)
			love.graphics.rectangle("fill",b.x,b.y,b.w,b.h)
			love.graphics.setColor(252,252,252)
			if b.clicked then
				love.graphics.setLineWidth(5)
			else
				love.graphics.setLineWidth(3)
			end
			love.graphics.rectangle("line",b.x,b.y,b.w,b.h)
			love.graphics.setLineWidth(3)
			love.graphics.setFont(textBoxFont)
			if b.drawSub then
				love.graphics.setColor(252,252,252,100)
				love.graphics.print(b.subtext,b.x+5,b.y+3)
			end
			if #b.text > 0 then
				b.drawSub = false
			else
				b.drawSub = true
			end
			love.graphics.setColor(252,252,252)
			love.graphics.print(b.text,b.x+5,b.y+3)
		end
		
		
		love.graphics.setColor(20,20,20)
		
		love.graphics.rectangle("fill",v.buttonX,v.buttonY,v.buttonW,v.buttonH,5,5)
		
		love.graphics.setColor(100,100,100)
		
		love.graphics.rectangle("line",v.buttonX,v.buttonY,v.buttonW,v.buttonH,5,5)
		
		love.graphics.setColor(252,252,252)
		
		love.graphics.setFont(normalFont)
		
		love.graphics.printf(v.buttonText,v.buttonX,v.buttonY+8,v.buttonW,"center")
	end
end

function newMessage(text,id,buttonText)
	local t = {textBoxes={}}
	local message = ""
	local textSize = string.len(text)
	local command = false
	local commandPoint = 0
	local commandTyp = 0
	local textboxes = 0
	local textBoxesTEXT = {}
	
	for i=1, textSize do
		local letter = string.sub(text,i,i)
		if command == false then
			if letter ~= "<" then
				message = message .. letter
			else
				command = true
				
				local start, fin = string.find(text,"textBox",i)
				
				if fin ~= nil and start ~= nil then
					local var1, var2 = string.find(text,">",fin)
					
					local parameters = string.sub(text,fin+2,var1-2)
					
					-- local output = {}
					
					-- for match in parameters:gmatch("%-?%d+") do
						-- func = assert(load("return " .. match))
						-- output[#output + 1] = func()
					-- end
					
					table.insert(textBoxesTEXT,parameters)
					
					textboxes = textboxes + 1
					
					commandPoint = var1 - 1
					commandTyp = 1
				end
			end
		else
			if i > commandPoint then
				command = false
			end
		end
	end
	
	local escapes = 0
	
	for word in string.gmatch(text, "%\n") do
		escapes = escapes + 1
	end
	
	t.messageID = id
	
	t.text = message
	t.w = string.len(message) * 12
	t.w = t.w + (140 * textboxes)
	t.h = 140 + (70 * textboxes) + (escapes * 12)
	t.x = (maxW / 2) - (t.w/2)
	t.y = (maxH / 2) - (t.h/2)
	
	t.buttonW = 100
	t.buttonH = 30
	t.buttonX = (maxW / 2) - (t.buttonW / 2)
	t.buttonY = t.y + t.h - (t.buttonH+10)
	if buttonText == nil then
		t.buttonText = "OK"
	else
		t.buttonText = buttonText
	end
	
	for i=1, textboxes do
		table.insert(t.textBoxes,newTextBox((maxW/2)-(145/2),t.y+(60*i)+(escapes * 20),textBoxesTEXT[i]))
	end
	
	if #t.textBoxes > 0 then
		if t.textBoxes[1].clicked ~= nil then
			t.textBoxes[1].clicked = true
		end
	end
	
	table.insert(messages,t)
end

function system_messages.mousepressed(x,y)
	for k, b in ipairs(messages) do
		for i, v in ipairs(b.textBoxes) do
			if x > v.x and x < v.x + v.w and y > v.y and y < v.y + v.h then
				if v.clicked then
					v.clicked = false
				else
					v.clicked = true
				end
			else
				if v.clicked then
					v.clicked = false
				end
			end
		end
		
		if x > b.buttonX and x < b.buttonX + b.buttonW and y > b.buttonY and y < b.buttonY + b.buttonH then
			messageConfirm(b.messageID)
		end
	end
end

function system_messages.keypressed(key)
	if key == "backspace" then
		for k, b in ipairs(messages) do
			for i, v in ipairs(b.textBoxes) do
				if v.clicked then
					local byteoffset = utf8.offset(v.text, -1)
					
					if byteoffset then
						v.text = string.sub(v.text, 1, byteoffset - 1)
					end
				end
			end
		end
	end
	if key == "tab" then
		for k, b in ipairs(messages) do
			for i, v in ipairs(b.textBoxes) do
				if v.clicked then
					if messages[k].textBoxes[i+1] ~= nil then
						v.clicked = false
						messages[k].textBoxes[i+1].clicked = true
						return
					else
						if i ~= 1 then
							v.clicked = false
							messages[k].textBoxes[1].clicked = true
						end
					end
				end
			end
		end
	end
	if key == "return" then
		for k, b in ipairs(messages) do
			messageConfirm(b.messageID)
		end
	end
	for k, b in ipairs(messages) do
		if b.messageID == 0 then
			if key == "escape" then
				love.event.quit()
			end
		end
	end
end

function system_messages.textinput(t)
	for k, b in ipairs(messages) do
		for i, v in ipairs(b.textBoxes) do
			if v.clicked then
				if string.len(v.text) < v.limit then
					if t ~= "a" and t ~= "A" then
						v.text = v.text .. t
					end
				end
			end
		end
	end
end

function newTextBox(x,y,subtext)
	local t = {x=x,y=y,w=145,h=40,clicked=false,text="",limit=7,subtext=subtext,drawSub=true}
	
	return t
end

function messageConfirm(id)

	if id == 1 then
		for k, b in ipairs(messages) do
			if id == b.messageID then
				for i, v in ipairs(b.textBoxes) do
					if i == 1 and tonumber(v.text) ~= nil then
						map_width = tonumber(v.text)
					end
					if i == 2 and tonumber(v.text) ~= nil then
						map_height = tonumber(v.text)
					end
				end
			end
		end
		
		resetTileMap()
	end
	
	if id == 2 then
		for k, b in ipairs(messages) do
			if id == b.messageID then
				for i, v in ipairs(b.textBoxes) do
					if love.filesystem.exists("/maps/map_".. tonumber(v.text)..".txt") then
						if i == 1 and tonumber(v.text) ~= nil then
							mapLoadID = tonumber(v.text)
						end
					else
						return
					end
				end
			end
		end
		
		loadMap()
	end
	
	if id == 3 then
		for k, b in ipairs(messages) do
			if id == b.messageID then
				for i, v in ipairs(b.textBoxes) do
					if entityMap[#entityMap] ~= nil then
						if entityMap[#entityMap].id == 0 then
							entityMap[#entityMap].id = tonumber(v.text)
						end
					end
					entity_drawID = tonumber(v.text)
				end
			end
		end
	end
	
	if id == 4 then
		for k, b in ipairs(messages) do
			if id == b.messageID then
				for i, v in ipairs(b.textBoxes) do
					events_table[#events_table].room = tonumber(v.text)
					newMessage("Enter X & Y for start: <textBox(X)><textBox(Y)>",5)
				end
			end
		end
	end
	
	if id == 5 then
		for k, b in ipairs(messages) do
			if id == b.messageID then
				for i, v in ipairs(b.textBoxes) do
					if i == 1 and tonumber(v.text) ~= nil then
						events_table[#events_table].goX = tonumber(v.text)
					end
					if i == 2 and tonumber(v.text) ~= nil then
						events_table[#events_table].goY = tonumber(v.text)
					end
				end
			end
		end
	end
	
	table.remove(messages,1)
end