local DB = require('../handler/economy.lua')

local jobs = {
    'Will you help me find my orange?\nIt fell in a bush full of bananas over there, but I could not find it.\nPlease go there and find my orange.',
    'I am trying to catch a flying mango, but it keeps disappearing.\nSo will you catch it and bring it to me?',
    'my pet rabbit has escaped!\nhe really like carrots\ncan you help lure him home?'
}
local responses = {
    'Yay, you found my orange!',
    'Yay, you found my mango!',
    'Yay, you found my rabbit!',
    'Yay, you did it!'
}
local fails = {
    "Thats not my orange, thats a banana!",
    "You didn't catch my mango? Too bad.",
    "Sorry, I was asking for a carrot, not a lime."
}

command.Register("work", "Your basic way of getting stars", "economy", function(msg, args)
    if command.Cooldown(msg, "payday", 30, "You're working too fast, slow down! Wait **%s** seconds before working again.") then return end
    local successrate  = math.random(1,100)
    local jobid = math.random(1, #jobs)
    local job = jobs[jobid]
    if successrate <= 60 then
        local response = responses[jobid]
        local earned = math.random(5,10)
		
        local id = DB.CreateRowUser(msg.author.id)
        local stars = DB.GetUserStars(id)
        stars = stars + earned
		
        -- Save changes
        DB.SetUserStars(id, stars)
		
		msg:reply({
            embed = {
                title = msg.author.name .. "'s work",
                description = job,
                fields = {
                    {name = tostring(response), value = "Heres " .. earned .. " :star:"},
                    {name = "Your balance is now:", value = DB.LongString(stars) .. " :star:"},
                },
                color = DISCORDIA.Color.fromRGB(170,26,232).value,
                timestamp = DISCORDIA.Date():toISO('T', 'Z')
            }
        })
    else
        local response = fails[jobid]
        assert(msg:reply({
            embed = {
                title = msg.author.name .. "'s work",
                description = job,
                fields = {
                    {name = tostring(response), value = "Please try again later!"},
                },
                color = DISCORDIA.Color.fromRGB(170,26,232).value,
                timestamp = DISCORDIA.Date():toISO('T', 'Z')
            }
        }))
    end
    end)

command.Register("bal", "See your balance of :star:", "economy", function(msg, args)
    local id = DB.CreateRowUser(msg.author.id)
    local stars = DB.GetUserStars(id)
    msg:reply {
        embed = {
            title = msg.author.name .. "'s Balance",
            fields = {
                {name = "You have:", value = DB.LongString(stars) .. " :star:"}
            },
            color = DISCORDIA.Color.fromRGB(170,26,232).value,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
    }
end)

command.Register("gamble", "Gamble your stars away and hope your lucky", "economy", function(msg,args)
	if command.Cooldown(msg, "gamble", 5, "Calm down on the gambling bro, wait **%s** seconds before gambling again.") then return end
	
	-- Initialize row
	local id = DB.CreateRowUser(msg.author.id)
	-- local stars_changing = DB.db:rowexec('SELECT stars_changing FROM users WHERE id = "' .. id .. '"')
	-- if stars_changing then return msg:reply("Your star balance is currently changing.") end
	local prize = tonumber(args[1])
	local win = false
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