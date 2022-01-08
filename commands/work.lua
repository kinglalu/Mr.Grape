require('../handler/economy.lua')
local DB = require('../db.lua')

local jobs = {
    'Will you help me find my orange?\nIt fell in a bush full of bananas over there, but I could not find it.\nPlease go there and find my orange.',
    'I am trying to catch a flying mango, but it keeps disappearing.\nSo will you catch it and bring it to me?',
    'my pet rabbit has escaped!\nhe really like carrots\ncan you help lure him home?'
}
local responses = {
    'Yay, you found my orange!',
    'Yay, you found my mango!',
    'Yay, you found my rabbit!',
    'Yay, you did it!'
}
local fails = {
    "Thats not my orange, thats a banana!",
    "You didn't catch my mango? Too bad.",
    "Sorry, I was asking for a carrot, not a lime."
}

command.Register("work", "Your basic way of getting stars", "economy", function(msg, args)
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
    
    if command.Cooldown(msg, "payday", cooldowntotal, "You're working too fast, slow down! Wait **%s** seconds before working again.") then return end
    
    local successrate  = math.random(1,100)
    local jobid = math.random(1, #jobs)
    local job = jobs[jobid]
    if jobid == 1 then
         if not items.orangedetector then 
            print("no detector")
        else
        local reductionO = items.orangedetector.quantity*2
        successrate = math.random(1,100-reductionO)
        if successrate < 0 then
            successrate = 1
        end
    end
     elseif jobid == 2 then
        if not items.mangodetector then 
            print("no detector")
        else
        local reductionM = items.mangodetector.quantity*2
        successrate = math.random(1,100-reductionM)
        if successrate < 0 then
            successrate = 1
        end
        end
    elseif jobid == 3 then
        if not items.carrotdetector then 
            print("no detector")
        else
        local reductionC = items.carrotdetector.quantity*2
        successrate = math.random(1,100-reductionC)
        if successrate < 0 then
            successrate = 1
        end
        end
    end

    if successrate <= 60 then
        local response = responses[jobid]
        local earned = math.random(5,10)
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
                title = msg.author.name .. "'s work",
                description = job,
                fields = {
                    {name = tostring(response), value = "Heres " .. earned .. " :star:"},
                    {name = "Your balance is now:", value = DB.LongString(stars) .. " :star:"},
                    {name = "ㅤ", value = NODECLUSTERS, inline = false},
                },
                color = EMBEDCOLOR,
                timestamp = DISCORDIA.Date():toISO('T', 'Z')
            }
        })
    else
        local response = fails[jobid]
        assert(msg:reply({
            embed = {
                title = msg.author.name .. "'s work",
                description = job,
                fields = {
                    {name = tostring(response), value = "Please try again later!"},
                    {name = "ㅤ", value = NODECLUSTERS, inline = false},
                },
                color = EMBEDCOLOR,
                timestamp = DISCORDIA.Date():toISO('T', 'Z')
            }
        }))
    end
end)