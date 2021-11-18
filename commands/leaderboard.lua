local DB = require('../handler/economy.lua')

command.Register("leaderboard", "leaderboard", "economy", function(msg,args)
	DB.db:rowexec('SELECT stars, id FROM users WHERE id = "' .. id .. '"')
end)