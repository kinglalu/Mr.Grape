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
