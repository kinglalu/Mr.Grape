local timer = require('timer')
local parse = require("url").parse

local process = require("coro-spawn")("youtube-dl", {
    args = { "-g", url },
    stdio = { nil, true, 2 }
})

-- Move this to table.lua
function tablelen(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end  


local musicfunc = {}

--[[

Music Queue

[
    {
        url,
        platform,
        user
    },
    ...
]


--]]

_G.MUSICQUEUE = {}

local conn

function musicfunc.joinVC(voiceChannel)
    if voiceChannel == nil then
        msg.channel:send("You are not in a vc!")
    else
        conn = voiceChannel:join(voiceChannel)
    end
end

function musicfunc.leaveVC(channel)
    print(tableLen(channel.connectedMembers))
    if tableLen(channel.connectedMembers) == 0 or channel == undefined then
        conn:close()
    end
end

CLIENT:on("voiceChannelLeave", function(member, channel)
    local clientInVC
    for _, v in pairs(channel.connectedMembers) do
        if v == CLIENT.id then
            clientInVC = true
            break
        end
    end
    if clientInVC then
        -- Doesn't get here
        print("Bot is in vc")
        timer.setInterval(3000000, leaveVC, channel)
        leaveVc()
    end
end)
return musicfunc