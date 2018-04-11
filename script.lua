script = {}

function script.load()
	script_storage = {
		-- Commands:
		-- <frameChng(num)> = Change frame of sprite --
		-- <sprChng(num)> = Change whole sprite      --
		-- <removeSelf> = Remove entity              --
		-- <move(dir,dist,spd,pause) = Move entity   --
	
		-- #001
		{
			"Hi bitch.",
			"Welcome to mall.",
			"Think you can make it here, huh?",
			"Well if you want to survive here I recommend you go to the old abondened Blue Navy.",
			"heh. You wont make it there...",
		},
		-- #002
		{
			"What you think you can fight me?",
			"...",
			"Ok.",
			"<move(1,50,1,1)>",
			"<pointerChng(3)>",
		},
		-- #003
		{
			"Hey dude stop rubbing it we get it ur though just go...",
			"...geez.",
		},
		-- #004
		{
			"I found a can of spam and now everyone wants a piece of me...",
			"Well let them try!!!",
		},
		-- #005
		{
			"...",
			"what?",
		},
		-- #006
		{
			"Beep bop. I am robot man",
			"...",
			"<sprChng(6)>",
			"Okay you got me I'm just a regular man...",
			"Its still a pretty sweet costume though right?",
			"<sprChng(5)>",
		},
	}
end