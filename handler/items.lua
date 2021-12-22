local DB = require('../db.lua')

--[[
TABLE Items
{
	"item name": {
		"quantity": 0 (Int)
	}
}
]]--

DB.KnownItems = {
	fan = {
		Emoji = "<:fan:908145885676986398> ",
		description = "Reduces cooldowns of some commands.",
		price = 350,
		userprice = 0
	},
	orangedetector = {
		Emoji = ":tangerine: ",
		description = "Increases the chance you find an orange in the orange job.",
		price = 100,
		userprice = 0
	},
	mangodetector = {
		Emoji = ":mango: ",
		description = "Increases the chance you find a mango in the mango job.",
		price = 100,
		userprice = 0
	},
	carrotdetector = {
		Emoji = ":carrot: ",
		description = "Increases the chance you find a carrot in the carrot job.",
		price = 100,
		userprice = 0
	},
	starmagnet = {
		Emoji = ":magnet: ",
		description = "Increases the amount of :star:s gained per job.",
		price = 250,
		userprice = 0
	},
	shovel = {
		Emoji = "<:shovel:908207500942258176> ",
		description = "Gives you more stars for digging job.",
		price = 305,
		userprice = 0
	}

}

-- ID from CreateUserRow
function DB.GetUserItems(id)
	local db_items = DB.db:rowexec('SELECT items FROM users WHERE id = "' .. id .. '"')
	local items = JSON.parse(db_items)
	
	for i,v in pairs(items) do
		if not DB.KnownItems[i] or not v.quantity or v.quantity == 0 then
			items[i] = nil
		end
	end
	
	return items
end

-- ID from CreateUserRow
function DB.SetUserItems(id, items)
	local stmt = DB.db:prepare[[
		UPDATE users SET items = ? WHERE id = ?
	]]
	
	stmt:bind(JSON.stringify(items), id)
	stmt:step()
	stmt:close()
	
	return items
end

function DB.CalculatePrice(id, itemid)
	local price = DB.KnownItems[itemid].price
	local items = DB.GetUserItems(id)
	local quantity  = 1;
	
	if items[itemid] ~= nil and items[itemid].quantity > 0 then
		quantity  = items[itemid].quantity / 2;
	end
	
	-- math.pow(price, quantity );
	return price * quantity
end

return DB;