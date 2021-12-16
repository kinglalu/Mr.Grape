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
