local DB = require('../handler/economy.lua')

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
    if command.Cooldown(msg, "payday", 30, "You're working too fast, slow down! Wait **%s** seconds before working again.") then return end
    local successrate  = math.random(1,100)
    local jobid = math.random(1, #jobs)
    local job = jobs[jobid]
    if successrate <= 60 then
        local response = responses[jobid]
        local earned = math.random(5,10)
		
        local id = DB.CreateRowUser(msg.author.id)
        local stars = DB.GetUserStars(id)
        stars = stars + earned
		
        -- Save changes
        DB.SetUserStars(id, stars)
		
		msg:reply({
            embed = {
                title = msg.author.name .. "'s work",
                description = job,
                fields = {
                    {name = tostring(response), value = "Heres " .. earned .. " :star:"},
                    {name = "Your balance is now:", value = DB.LongString(stars) .. " :star:"},
                },
                color = DISCORDIA.Color.fromRGB(170,26,232).value,
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
                },
                color = DISCORDIA.Color.fromRGB(170,26,232).value,
                timestamp = DISCORDIA.Date():toISO('T', 'Z')
            }
        }))
    end
end)