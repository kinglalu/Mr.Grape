local start = os.time();

local function SecondsToClock()
    local seconds = os.time() - start
   
    local output = ""
    local comma = ""
    
    local days = math.floor(seconds / 86400)
    if days > 0 then output = output .. tostring(days) .. " Days" comma = ", " end
    
    seconds = seconds - days * 86400
    local hours = math.floor(seconds / 3600 )
    if hours > 0 then output = output .. comma .. tostring(hours) .. " Hours" comma = ", " end
    
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds / 60) 
    if minutes > 0 then output = output .. comma .. tostring(minutes) .. " Minutes" comma = ", " end
    
    seconds = seconds - minutes * 60
    if seconds > 0 then output = output .. comma .. tostring(seconds) .. " Seconds" end
    
    return output
end
 function gettotalusers()
    local users = 0
    for guild in CLIENT.guilds:iter() do
        users = users + guild.totalMemberCount
    end
    return users
 end

command.Register("info", "Gives you info about Mr Grape!", "utility", function(msg, args)
    msg:reply{
        embed = {
            title = "Info",
            thumbnail = {url = 'https://cdn.discordapp.com/attachments/756356493623820309/808114506780770324/emoji.png'},
            fields = {
                { name = "Uptime:", value = SecondsToClock() },
                {name = "Credits:", value = "Kinglalu, Divide, Linuxterm\n JS version by DAONE\n Emojis by Goobermeister\n Original bot by Horsey4 & Airplane Bong"},
                {name = "Number of servers:", value = #CLIENT.guilds},
                {name = "Total Users: ", value = gettotalusers() },
                {name = "ㅤ", value = "Powered by [NodeClusters](https://nodeclusters.com/billing/link.php?id=8). Nodeclusters is affordable web and vps hosting for as low as $3 a month.", inline = false},
            },
            color = EMBEDCOLOR,
            timestamp = DISCORDIA.Date():toISO('T','Z')
        }
    }
end)