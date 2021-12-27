local DB = require('../db.lua')

function DB.GetUserLastDaily(id)
	return DB.rowexecb("SELECT last_daily FROM users WHERE id = ?", id)
end

function DB.SetUserDailyStars(id, time)
	return DB.rowexecb("UPDATE users SET last_daily = ? WHERE id = ?", time, id)
end

function DB.GetUserStars(id)
	return DB.rowexecb("SELECT stars FROM users WHERE id = ?", id)
end

function DB.SetUserStars(id, stars)
	return DB.rowexecb("UPDATE users SET stars = ? WHERE id = ?", stars, id)
end

return DB