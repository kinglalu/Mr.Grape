local DB = require('../handler/economy.lua')

command.Register("gamble", "Gamble your stars away and hope your lucky", "economy", function(msg,args)
	if command.Cooldown(msg, "gamble", 5, "Calm down on the gambling bro, wait **%s** seconds before gambling again.") then return end
	
	local prize = tonumber(args[1])
	local win = false
	local id = DB.CreateRowUser(msg.author.id)
	local stars = DB.GetUserStars(id)
	local gambleembed = {
		title = msg.author.name.."'s Gamble",
		fields = {
			{name = "Ok, if you roll an even number you win, if you roll an odd number, you lose.", value = "ㅤ"}, 
		},
		color = DISCORDIA.Color.fromRGB(170,26,232).value,
		timestamp = DISCORDIA.Date():toISO('T', 'Z')
	}
	
    if prize == nil or prize < 0 or prize == 0 then
		msg:reply("That's not a valid number to gamble!")
    elseif prize > stars then
		msg:reply("You don't have enough :star:!")
    else
		-- (1,2,3,4,5)
		local odds = math.random(1,5)
		local botmsg = assert(msg:reply{ embed = gambleembed })
		
		table.insert(gambleembed.fields, {name = "You rolled a...", value = "ㅤ"})
		table.insert(gambleembed.fields, {name = odds, value = "ㅤ"})
			
		if odds % 2 == 0 then
			stars = stars + prize
			table.insert(gambleembed.fields, {name = "Congrats! You won "..prize..":star:", value = "ㅤ"})
		else
			stars = stars - prize
			table.insert(gambleembed.fields, {name = "Rip. You lost "..prize..":star:", value = "ㅤ"})
		end
		
        -- Save changes
        DB.SetUserStars(id, stars)
		
		TIMER.setTimeout(2000, coroutine.wrap(function()
			botmsg:setEmbed(gambleembed)
		end))
    end
end)