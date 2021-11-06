local DB = require('../handler/economy.lua')

command.Register("bal", "See your balance of :star:", "economy", function(msg, args)
    local id = DB.CreateRowUser(msg.author.id)
    local stars = DB.GetUserStars(id)
    msg:reply {
        embed = {
            title = msg.author.name .. "'s Balance",
            fields = {
                {name = "You have:", value = DB.LongString(stars) .. " :star:"}
            },
            color = DISCORDIA.Color.fromRGB(170,26,232).value,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
    }
end)