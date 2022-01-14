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
		price = 350
	},
	orangedetector = {
		Emoji = ":tangerine: ",
		description = "Increases the chance you find an orange in the orange job.",
		price = 100
	},
	mangodetector = {
		Emoji = ":mango: ",
		description = "Increases the chance you find a mango in the mango job.",
		price = 100
	},
	carrotdetector = {
		Emoji = ":carrot: ",
		description = "Increases the chance you find a carrot in the carrot job.",
		price = 100
	},
	starmagnet = {
		Emoji = ":magnet: ",
		description = "Increases the amount of :star:s gained per job.",
		price = 250
	},
	shovel = {
		Emoji = "<:shovel:908207500942258176> ",
		description = "Gives you more stars for digging job.",
		price = 305
	},
	tieronepickaxe = {
		Emoji = "<:tier1pick:929517969799798884>",
		description = "Allows you to obtain tier 1 ores while using +dig.",
		price = 800
	},
	tiertwopickaxe = {
		Emoji = "<:tier2pick:929517970051444756>",
		description = "Allows you to obtain tier 2 ores while using +dig.",
		price = 1600
	},
	tierthreepickaxe = {
		Emoji = "<:tier3pick:929517970101788722>",
		description = "Allows you to obtain tier 3 ores while using +dig.",
		price = 2400
	}

}

-- ID from CreateUserRow
function DB.GetUserItems(id)
	local db_items = DB.rowexecb('SELECT items FROM users WHERE id = ?', id)
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
	return DB.rowexecb("UPDATE users SET items = ? WHERE id = ?", JSON.stringify(items), id)
end

function DB.CalculatePrice(id, itemid)
	local price = DB.KnownItems[itemid].price
	local items = DB.GetUserItems(id)
	local quantity  = 1;
	
	if items[itemid] ~= nil and items[itemid].quantity > 0 then
		quantity = items[itemid].quantity / 2;
	end
	
	if quantity < 1 then quantity = 1 end
	
	-- math.pow(price, quantity );
	return math.min(math.round(price * quantity), price * 40)
end

return DB;