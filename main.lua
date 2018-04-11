bump = require 'libs.bump'
require "libs.camera"
require "game"
require "world_map"
require "world_sprites"
require "world_entities"
require "message"

function love.load()
	maxW, maxH = love.graphics.getDimensions()
	world_sprites.load()
	game.load()
	world_map.load()
	world_entities.load()
	script.load()
	message.load()
end

function love.draw()
	camera:set()

	game.draw()
	world_entities.draw()
	
	love.graphics.setColor(252,252,252)
	
	camera:unset()
	
	if npcActing and drawMessage then
		message.draw()
	end
	
	love.graphics.print("Player X "..player.x/32)
	love.graphics.print("Player Y "..player.y/32,0,12)
	love.graphics.print("Player Camera X "..camera.x,0,24)
	love.graphics.print("Player Camera Y "..camera.y,0,37)
	
	local dist = ((player.y+player.h)+maxH/2)-(player.h/2)
	
	love.graphics.print("Player Dist "..dist,0,50)
	
	love.graphics.print("GRID OFFSET Y "..gridOffsetY,0,66)
	
	love.graphics.setColor(252,252,252)
end

function love.update(dt)
	game.update(dt)
	if npcActing and stopActing == false then
		for i, v in ipairs(world_messages) do
			if string.find(script_storage[v.pointer1][text.num],"<") == nil then
				message.update(dt,script_storage[v.pointer1][text.num])
			else
				messageAction(script_storage[v.pointer1][text.num],v.pointer1)
			end
		end
	end
	
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
end

function drawBox(box, r,g,b,typ)
	love.graphics.setColor(r,g,b,50)
	love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
	love.graphics.setColor(r,g,b)
	love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
	love.graphics.setColor(252,252,252)
end

function drawBlock(box, r,g,b,typ)
	love.graphics.setColor(r,g,b)
	love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
	love.graphics.setColor(252,252,252)
end

function love.keypressed(key)
	if player.move then
		if key == "right" then
			player.frame = 5
		elseif key == "left" then
			player.frame = 5
		end
		if key == "up" then
			player.frame = 3
		elseif key == "down" then
			player.frame = 1
		end
	end
	if #world_messages > 0 and npcActing then
		if key == "z" and text.done then
			if script_storage[player.NPCpointer1][text.num+1] == nil then
				message.close()
			else
				message.resetVar()
				text.num = text.num + 1
			end
		end
	end
	if key == "u" then
		if showColls then
			showColls = false
		else
			showColls = true
		end
	end
end