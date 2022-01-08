require('../handler/economy.lua')
local DB = require('../db.lua')

command.Register("gamble", "Gamble your stars away and hope your lucky", "economy", function(msg,args)
	if command.Cooldown(msg, "gamble", 5, "Calm down on the gambling bro, wait **%s** seconds before gambling again.") then return end
	
	local prize = tonumber(args[1])
	local win = false
	local id = DB.CreateRowUser(msg.author)
	local stars = DB.GetUserStars(id)
	local ge = {
		title = msg.author.name.."'s Gamble",
		fields = {
			{name = "Ok, if you roll an even number you win, if you roll an odd number, you lose.", value = utf8.char(0x1f3b2)}, 
		},
		color = EMBEDCOLOR,
		timestamp = DISCORDIA.Date():toISO('T', 'Z')
	}
	
    if prize > 1e6 or prize == nil or prize < 0 or prize == 0 then
		msg:reply("That's not a valid number to gamble!")
    elseif prize > stars then
		msg:reply("You don't have enough :star:!")
    else
		local botmsg = assert(msg:reply{ embed = ge })
		-- (1,2,3,4,5)
		local odds = math.random(1,5)
		
		table.insert(ge.fields, {name = "You rolled a...", value = tostring(odds)})
			
		if odds % 2 == 0 then
			stars = stars + prize
			table.insert(ge.fields, {name = "Congrats!", value = "You won " .. prize .. " :star:"})
		else
			stars = stars - prize
			table.insert(ge.fields, {name = "Rip.", value = "You lost " .. prize .. " :star:"})
		end
		
        -- Save changes
        DB.SetUserStars(id, stars)
		
		TIMER.setTimeout(2000, coroutine.wrap(function()
			botmsg:setEmbed(ge)
		end))
    end
end)