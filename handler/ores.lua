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
	Copper = {
		Emoji = "<:copper:776577290506600489>",
		Tier = 1
	},
	Tin = {
		Emoji = "<:tin:776581611193368579>",
		Tier = 1
	},
	Iron = {
		Emoji = "<:iron:776582852065230858>",
		Tier = 1
	},
	Bronze = {
		Emoji = "<:bronze:776581702318424134>",
		Tier = 1
	},
	Silver = {
		Emoji = "<:silver:776578867988267059>",
		Tier = 1
	},
	Lead = {
		Emoji = "<:lead:776579886637776908>",
		Tier = 1
	},
	Gold = {
		Emoji = "<:gold:776585426689327105>",
		Tier = 2
	},
	Platinum = {
		Emoji = ":platinum:776586722560966666>",
		Tier = 2
	},
	Titanium = {
		Emoji = "<:titanium:776587848924135434>",
		Tier = 2
	},
	Obsidian = {
		Emoji = "<:obsidian:776589898039296021>",
		Tier = 2
	},
	Cobalt = {
		Emoji = "<:cobalt:776590825412624414>",
		Tier = 2
	},
	Goshine = {
		Emoji = "<:goshine:776592415209029643>",
		Tier = 2
	},
	Fasalt = {
		Emoji = "<:fasalt:776598681218056203>",
		Tier = 2
	},
	Maclantite = {
		Emoji = "<:maclantite:776598697022324769>",
		Tier = 2
	},
	Magmanite = {
		Emoji = "<a:magamanite:776607429034770494>",
		Tier = 3
	},
	Rainbonite = {
		Emoji = "<a:rainbonite:776596286887165962>",
		Tier = 3
	},
	Starium = {
		Emoji = "<a:starium:776601907254788107>",
		Tier = 3
	},
	Lumionite = {
		Emoji = "<a:lumanite:776604908701876267>",
		Tier = 3
	},
	Hellinite = {
		Emoji = "<:hellinite:776619917193117728>",
		Tier = 3
	},
	Grapium = {
		Emoji = "<a:grapium:776612094929010688>",
		Tier = 3
	},
	Heaveninite = {
		Emoji = "<:heaveninite:778736725794619393>",
		Tier = 3
	},
	Erdon = {
		Emoji = "<a:Erdon:776623794622038066>",
		Tier = 3
	},
	Shakerium = {
		Emoji = "<a:shakerium:776875604967948293>",
		Tier = 3
	},
	Kelite = {
		Emoji = ":question:",
		Tier = 3
	},
	Limeinite = {
		Emoji = ":question:",
		Tier = 3
	}

}

-- ID from CreateUserRow
function DB.GetUserOres(id)
	local db_ores = DB.rowexecb('SELECT ores FROM users WHERE id = ?', id)
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
	DB.rowexecb("UPDATE users SET ores = ? WHERE id = ?", JSON.stringify(ores), id);
	return ores
end

return DB
