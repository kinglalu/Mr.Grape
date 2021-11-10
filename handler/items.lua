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
	apple = {
		Emoji = ":apple:",
		description = "test apple",
		price = 3
	},
	fan = {
		Emoji = ":fan:",
		description = "Reduces cooldowns of some commands.",
		price = 100
	},
	orangedetector = {
		Emoji = ":tangerine:",
		description = "Increases the chance you find an orange in the orange job.",
		price = 100
	},
	mangodetector = {
		Emoji = ":mango:",
		description = "Increases the chance you find a mango in the mango job.",
		price = 100
	},
	carrotdetector = {
		Emoji = ":carrot:",
		description = "Increases the chance you find a carrot in the carrot job.",
		price = 100
	},
	starmagnet = {
		Emoji = ":magnet:",
		description = "Increases the amount of :star:s gained per job.",
		price = 150
	},
	shovel = {
		Emoji = ":shovel:",
		description = "Gives you more stars for digging job.",
		price = 175
	}

}

-- ID from CreateUserRow
function DB.GetUserItems(id)
	local db_items = DB.db:rowexec('SELECT items FROM users WHERE id = "' .. id .. '"')
	local items = JSON.parse(db_items)
	
	for i,v in pairs(items) do
		if not DB.KnownItems[i] or not v.quantity or v.quantity == 0 then
			Items[i] = nil
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
	
	return items
end

return DB