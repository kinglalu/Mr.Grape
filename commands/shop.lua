require('../handler/items.lua')
local DB = require('../db.lua')
    
command.Register("shop", "Displays the shop for items you can buy with :star:", "economy", function(msg, args)
	local items = DB.KnownItems
	local id = DB.CreateRowUser(msg.author)
	local embed = {
		title = "Shop",
		description = "`Buy an item by using "..PREFIX.."buy <itemname>!` \n `Item prices are increased based on amount owned.`",
		fields = {},
		color = EMBEDCOLOR,
		timestamp = DISCORDIA.Date():toISO('T', 'Z')
	}
	
	for itemid,data in pairs(items) do
		table.insert(embed.fields, {name=data.Emoji..itemid,value=data.description..'\n'.. DB.CalculatePrice(id, itemid) ..':star:'})
	end
	
	assert(msg:reply{embed = embed})
end)