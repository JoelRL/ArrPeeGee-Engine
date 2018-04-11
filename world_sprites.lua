world_sprites = {}

function world_sprites.load()
	sprite_sheets = {
		love.graphics.newImage("/char.png"),
		love.graphics.newImage("/spr/entities/npc_spr.png"),
	}

	sprites = {
		{
			love.graphics.newQuad(0,0,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
			love.graphics.newQuad(32,0,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
			love.graphics.newQuad(64,0,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
			love.graphics.newQuad(96,0,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
			love.graphics.newQuad(128,0,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
			love.graphics.newQuad(160,0,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
			love.graphics.newQuad(0,48,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
			love.graphics.newQuad(32,48,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
			love.graphics.newQuad(64,48,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
			love.graphics.newQuad(96,48,32,48,sprite_sheets[1]:getWidth(),sprite_sheets[1]:getHeight()),
		},
		{
			love.graphics.newQuad(0,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(32,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(0,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(32,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
		},
		{
			love.graphics.newQuad(64,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(64+32,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(64,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(64+32,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
		},
		{
			love.graphics.newQuad(128,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(128+32,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(128,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(128+32,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
		},
		{
			love.graphics.newQuad(192,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(192+32,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(192,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(192+32,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
		},
		{
			love.graphics.newQuad(256,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(256+32,0,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(256,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
			love.graphics.newQuad(256+32,48,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight()),
		},
	}
	
	--loadSprites()
end

function draw_sprite(t)

	--love.graphics.draw(sprite_sheets[2],sprites[3][1],300,300)

	local var = 0

	if t.typ == "player" then
		var = 1
	elseif t.typ == "npc" then
		var = t.spr
	else
		error("Sprite type " .. t.typ .. " doesn't exist")
	end
	
	love.graphics.draw(sprite_sheets[t.spriteSheet],sprites[var][t.frame],t.x+t.spriteOffsetX,t.y+t.spriteOffsetY,0,t.spriteScale,1)
end

function loadSprites()
	local w = sprite_sheets[2]:getWidth() / 64
	local h = sprite_sheets[2]:getHeight() / 96
	local num = w * h
	local x = 0
	local y = 0
	local sprN = 1
	
	table1 = {}
	
	for i=1, 2 do
		
		for b=1, 5 do
			print("NUM "..b)
			print("X "..x)
			print("Y "..y)
			local spr = love.graphics.newQuad(x,y,32,48,sprite_sheets[2]:getWidth(),sprite_sheets[2]:getHeight())
			table1[sprN] = spr
			if b < 5 then
				x = x + 32
				if x > 64 then
					x = 0
					y = y + 48
				end
			end
			sprN = sprN + 1
		end
		table.insert(sprites,table1)
	end
end