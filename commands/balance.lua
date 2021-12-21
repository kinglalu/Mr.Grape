local DB = require('../handler/economy.lua')

command.Register("bal", "See your balance of :star:", "economy", function(msg, args)
    local person = command.FirstMention(msg)
    local id = DB.CreateRowUser(person)
    local stars = DB.GetUserStars(id)
    msg:reply {
        embed = {
            title = person.name .. "'s Balance",
            fields = {
                {name = person.name.." has:", value = DB.LongString(stars) .. " :star:"}
            },
            color = EMBEDCOLOR,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
    }
end)