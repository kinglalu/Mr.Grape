require('../handler/economy.lua')
require('../handler/items.lua')
local DB = require('../db.lua')

command.Register("buy", "Purchase an item from the shop with :star:", "economy", function(msg, args)
    local shopitems = DB.KnownItems
    local id = DB.CreateRowUser(msg.author)
	local items = DB.GetUserItems(id)
    local stars = DB.GetUserStars(id)
    local purchase = string.lower(tostring(args[1]))
	
    if purchase == nil then
        msg:reply("Please choose a valid item!")
		return nil;
    end
	
	local v = shopitems[purchase]
	
	if not v then
		msg:reply("Thats not a valid item!")
		return nil
	end
	
	print(DB.CalculatePrice(id, purchase), stars)
	
	if stars < DB.CalculatePrice(id, purchase) then
		msg:reply("You don't have enough :star:")
		return nil
	end
	
	if not items[purchase] then items[purchase] = { quantity = 0 } end
	
	items[purchase].quantity = items[purchase].quantity + 1
	stars = stars - DB.CalculatePrice(id, purchase)
	DB.SetUserStars(id, stars)
	DB.SetUserItems(id, items)
	msg:reply("Purchase Complete!")
end)