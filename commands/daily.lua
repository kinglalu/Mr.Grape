local DB = require('../handler/economy.lua')


command.Register("daily", "Collect an amount of stars every 24 hours!", "economy", function(msg, args)
    local id = DB.CreateRowUser(msg.author)
    local items = DB.GetUserItems(id)
    local stars = DB.GetUserStars(id)

    if command.Cooldown(msg, "daily", 86400, "You already collected your daily amount! Wait **%s** seconds before collecting again.") then return end
    
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