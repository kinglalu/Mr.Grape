local DB = require('../db.lua')

function DB.GetUserStars(id)
	return DB.db:rowexec('SELECT stars FROM users WHERE id = "' .. id .. '"')
end

function DB.SetUserStars(id, stars)
	DB.db:exec('UPDATE users SET stars = ' .. DB.LongString(stars) .. ' WHERE id = "' .. id .. '"')
end

return DB