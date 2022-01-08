require('../handler/economy.lua')
require('../handler/items.lua')
local DB = require('../db.lua')

command.Register("dig", "dig for :star:", "economy", function(msg, args)
    local id = DB.CreateRowUser(msg.author)
    local items = DB.GetUserItems(id)
    local stars = DB.GetUserStars(id)
    local cooldowntotal = 30
    
    if items.fan then 
        cooldowntotal = math.max(cooldowntotal - items.fan.quantity, 1)
    end

    if command.Cooldown(msg, "dig", cooldowntotal, "You're digging too fast, the mines are gonna go bare! Wait **%s** seconds before digging again.") then return end
	
    local earned = math.random(7,14)
	
	local efields = {}
	
	if items.shovel then
		if math.random(0, 3) == 0 then
			local msg = ""
			local loss = math.round(math.max(math.random(1, items.shovel.quantity / 80), 1))
			
			if loss > 1 then
				msg = loss .. " of your shovels were chipped."
			else
				msg = "A shovel was chipped."
			end
			
			items.shovel.quantity = items.shovel.quantity - loss
			
			DB.SetUserItems(id, items)
			
			table.insert(efields, {name = "Oh no!", value = msg })
		end
		
		earned = earned + math.round(items.shovel.quantity / 2)
	end
	
	stars = stars + earned

    DB.SetUserStars(id, stars)
    
	table.insert(efields, {name = "Your balance is now:", value = DB.LongString(stars) .. " :star:"})
	
	msg:reply({
        embed = {
            title = msg.author.name .. "'s dig",
			description = "**You dug up "..earned.." :star:**",
            fields = efields,
            color = EMBEDCOLOR,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
    })

end)