--[[
    https://github.com/stepelu/lua-ljsqlite3
    https://scilua.org/ljsqlite3.html
    
    Considerations:
    
    sqlite int Minimum is -(263) == -9223372036854775808 and maximum is 263 - 1 == 9223372036854775807
]]

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

local sql = require("sqlite3")
local db = sql.open("db.sqlite3")

db:exec[[
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY NOT NULL,
    items TEXT NOT NULL,
    ores TEXT NOT NULL,
    stars INTEGER NOT NULL,
    stars_changing INTEGER NOT NULL,
    UNIQUE(id)
);
]]

-- tostring adds "LL" suffix, messes with SQL
function long2str(x)
    return tostring(x):gsub("[^0-9.]", "")
end

function CreateRowUser(id)
	id = tostring(id)
	
    local exists = db:rowexec('SELECT EXISTS(SELECT 1 FROM users WHERE id = "' .. id .. '")')

    -- Create row
    if exists == 0 then
        db('INSERT INTO users (id, stars, items, ores, stars_changing) VALUES ("' .. id .. '", 0, "{}", "{}", 0)')
    end
	
	return id
end

command.Register("work", "Your basic way of getting stars", "economy", function(msg, args)
    if command.Cooldown(msg, "payday", 30, "You're working too fast, slow down! Wait **%s** seconds before working again.") then return end
    local successrate  = math.random(1,100)
    local jobid = math.random(1, #jobs)
    local job = jobs[jobid]
    if successrate <= 60 then
        local response = responses[jobid]
        local earned = math.random(5,10)
		
        local id = CreateRowUser(msg.author.id)
        local stars = db:rowexec('SELECT stars FROM users WHERE id = "' .. id .. '"')
        stars = stars + earned
		
        -- Save changes
        db:exec('UPDATE users SET stars = ' .. long2str(stars) .. ' WHERE id = "' .. id .. '"')
		
		msg:reply({
            embed = {
                title = msg.author.name .. "'s work",
                description = job,
                fields = {
                    {name = tostring(response), value = "Heres " .. earned .. " :star:"},
                    {name = "Your balance is now:", value = long2str(stars) .. " :star:"},
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

command.Register("bal", "See your balance of :star:", "economy", function(msg, args)
    local id = CreateRowUser(msg.author.id)
    local stars = db:rowexec('SELECT stars FROM users WHERE id = "' .. id .. '"')
    msg:reply {
        embed = {
            title = msg.author.name .. "'s Balance",
            fields = {
                {name = "You have:", value = long2str(stars) .. " :star:"}
            },
            color = DISCORDIA.Color.fromRGB(170,26,232).value,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
    }
end)
command.Register("gamble", "Gamble your stars away and hope your lucky", "economy", function(msg,args)
	if command.Cooldown(msg, "gamble",5, "Calm down on the gambling bro, wait **%s** seconds before gambling again.") then return end
	
	local id = CreateRowUser(msg.author.id)
    local stars_changing = db:rowexec('SELECT stars_changing FROM users WHERE id = "' .. id .. '"')
	
	if stars_changing then return msg:reply("Your star balance is currently changing.") end
	
	msg.reply("Placeholder")
end)