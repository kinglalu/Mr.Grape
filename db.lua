--[[
    https://github.com/stepelu/lua-ljsqlite3
    https://scilua.org/ljsqlite3.html
    
    Considerations:
    
    sqlite int Minimum is -(263) == -9223372036854775808 and maximum is 263 - 1 == 9223372036854775807
]]


local exports = {}

local sql = require("sqlite3")
local db = sql.open("grape.db")

db:exec[[
CREATE TABLE IF NOT EXISTS users (
	id INTEGER PRIMARY KEY NOT NULL,
	tag TEXT NOT NULL,
	items TEXT NOT NULL,
	ores TEXT NOT NULL,
	stars INTEGER NOT NULL,
	stars_changing INTEGER NOT NULL,
	last_daily INTEGER,
	UNIQUE(id)
);
]]

exports.sql = sql
exports.db = db


-- tostring adds "LL" suffix, messes with SQL
function exports.LongString(x)
    return tostring(x):gsub("[^0-9.]", "")
end

function err(code, msg)
  error("ljsqlite3 db["..code.."] "..msg)
end

function exports.rowexecb(statement, ...)
	local binds={...}
    
	local stmt = db:prepare(statement)
	stmt:bind(table.unpack(binds))
	
	local res = stmt:_step()
	if stmt:_step() then
		err("misuse", "multiple records returned, 1 expected")
	end
	
	stmt:close()
	
	if res then
		return unpack(res)
	else
		return nil
	end
end

function exports.CreateRowUser(user)
	local id = user.id
	
	local exists = exports.rowexecb("SELECT EXISTS(SELECT 1 FROM users WHERE id = ?)", id)

	-- Create row
    if exists == 0 then
		exports.rowexecb('INSERT INTO users (id, tag, stars, items, ores, stars_changing) VALUES (?, ?, 0, "{}", "{}", 0)', id, user.tag)
    else
		local tag = exports.rowexecb('SELECT tag, id FROM users WHERE id = ?', id)
		
		-- tag outdated
		if tag ~= user.tag then
			exports.rowexecb("UPDATE users SET tag = ? WHERE id = ?", user.tag, id)
		end
	end
	
	return id
end

return exports