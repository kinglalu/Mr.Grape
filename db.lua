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
    id TEXT PRIMARY KEY NOT NULL,
    items TEXT NOT NULL,
    ores TEXT NOT NULL,
    stars INTEGER NOT NULL,
    stars_changing INTEGER NOT NULL,
    UNIQUE(id)
);
]]

exports.sql = sql
exports.db = db


-- tostring adds "LL" suffix, messes with SQL
function exports.LongString(x)
    return tostring(x):gsub("[^0-9.]", "")
end

function exports.CreateRowUser(id)
	id = tostring(id)
	
    local exists = db:rowexec('SELECT EXISTS(SELECT 1 FROM users WHERE id = "' .. id .. '")')

    -- Create row
    if exists == 0 then
        db('INSERT INTO users (id, stars, items, ores, stars_changing) VALUES ("' .. id .. '", 0, "{}", "{}", 0)')
    end
	
	return id
end

return exports