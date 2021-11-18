local DB = require('../handler/economy.lua')
local MAX_COLUMNS = 10

command.Register("leaderboard", "leaderboard", "economy", function(msg,args)
	local stmt = DB.db:prepare[[
		SELECT id, tag, stars FROM users ORDER BY stars DESC
	]]
	
	local list = ''
	
	for i=0,MAX_COLUMNS do
		local step = stmt:step()
		
		if step then
			local id, tag, stars = unpack(step)
			list = list .. '**' .. (i + 1) .. ')** ' .. tag .. ': ' .. DB.LongString(stars) .. ' :star:\n'
		end
	end
	
	stmt:close();
	
	msg:reply{
		embed = {
			title = 'Leaderboard',
			description = list:sub(0, 512),
		},
	}
end)