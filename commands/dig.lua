local DB = require('../handler/economy.lua')

command.Register("dig", "dig for :star:", "economy", function(msg, args)
    local id = DB.CreateRowUser(msg.author)
    local items = DB.GetUserItems(id)
    local stars = DB.GetUserStars(id)
    local cooldowntotal = 30
    
    if not items.fan  then
        cooldowntotal = 30
    else 
        cooldowntotal = cooldowntotal - items.fan.quantity
        if cooldowntotal < 1 then
            cooldowntotal = 1
        end
    end

    if command.Cooldown(msg, "dig", cooldowntotal, "You're digging too fast, the mines are gonna go bare! Wait **%s** seconds before digging again.") then return end

    local earned = math.random(7,14)
		if not items.shovel then
            stars = stars + earned
        else
            earned = earned + items.shovel.quantity
            stars = stars + earned
        end

    DB.SetUserStars(id, stars)
    msg:reply({
        embed = {
            title = msg.author.name .. "'s dig",
            fields = {
                {name = "You dug up "..earned.." :star:", value = "ㅤ"},
                {name = "Your balance is now:", value = DB.LongString(stars) .. " :star:"},
            },
            color = EMBEDCOLOR,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
    })

end)