local DB = require('../db.lua')

--[[
TABLE ores
{
	"ore name": {
		"quantity": 0
	}
}
]]--

DB.KnownOres = {
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
	}

}

-- ID from CreateUserRow
function DB.GetUserOres(id)
	local db_ores = DB.db:rowexec('SELECT ores FROM users WHERE id = "' .. id .. '"')
	local ores = JSON.parse(db_ores)
	
	for i,v in pairs(ores) do
		if not DB.KnownOres[i] or not v.quantity or v.quantity == 0 then
			ores[i] = nil
		end
	end
	
	return ores
end

-- ID from CreateUserRow
function DB.SetUserOres(id, ores)
	local stmt = DB.db:prepare[[
		UPDATE users SET ores = ? WHERE id = ?
	]]
	
	stmt:bind(JSON.stringify(ores), id)
	stmt:step()
	stmt:close()
	
	return ores
end

return DB
