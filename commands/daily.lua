require('../handler/items.lua')
require('../handler/economy.lua')
local DB = require('../db.lua')

local second = 6e3
local hour = second * 60
local day = hour * 24

command.Register("daily", "Collect an amount of stars every 24 hours!", "economy", function(msg, args)
    local id = DB.CreateRowUser(msg.author)
    local items = DB.GetUserItems(id)
    local stars = DB.GetUserStars(id)
	local lastDaily = DB.GetUserLastDaily(id)
	
	local seconds = os.time()
	
	print(DB.LongString(lastDaily), seconds)
	
	if lastDaily == nil or (lastDaily + day) < seconds then
		DB.SetUserDailyStars(id, seconds)
	else
		msg:reply("You already collected your daily amount!")
		return nil
	end
	
	local earned = math.random(20,30)
	if not items.starmagnet then
		stars = stars + earned
	else
		earned = earned + items.starmagnet.quantity
		stars = stars + earned
	end


	-- Save changes
	DB.SetUserStars(id, stars)
	
	msg:reply({
		embed = {
			title = "Daily Stars",
			fields = {
				{name = msg.author.name.." got ", value = earned.. " :star:"},
				{name = "Your balance is now:", value = DB.LongString(stars) .. " :star:"},
				{name = "ㅤ", value = NODECLUSTERS, inline = false},
			},
			color = EMBEDCOLOR,
			timestamp = DISCORDIA.Date():toISO('T', 'Z')
		}
	})
end)