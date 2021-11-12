local timer = require('timer')
-- Replace url.lua with this
local parse = require("url").parse

-- TODO: Move this to table.lua
function tableLen(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end  


local musiclib = {}

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

local conn
-- Might not want to do it this way
local botVoiceChannelId

-- Library

CLIENT:on("voiceChannelLeave", function(member, channel)
    if botVoiceChannelId == channel.id and #channel.connectedMembers == 1 then
        print("The bot is alone")
        -- Disconnect from VC after 5 minutes
        timer.setTimeout(300000, musiclib.leaveVC())
    end
end)

musiclib.queue = {}

function musiclib.play(query, msg)
    print("Requested " .. query)

    args = {}
    if (parse(query).hostname == "youtube.com") then
        args = { "-g", query }
    else
        args = { "-g", "ytsearch:\"" .. query .. "\"" }
    end
    print(FUNCTIONS.print_table(args))
    local process = require("coro-spawn")("yt-dlp", {
        args = args,
        stdio = { nil, true, 2 }
    })

    musiclib.joinVC(msg.member.voiceChannel)

    for chunk in process.stdout.read do
        print(chunk)
        for _, ytURL in pairs(chunk:split('\n')) do
            local mime = parse(ytURL, true).query.mime
            if mime and mime:find("audio") == 1 then
                musiclib.queueAdd(query, ytURL)
                conn:playFFmpeg(ytURL)
            end
        end
    end
end

function musiclib.queueAdd(url, ytURL)
    print(ytURL)
    musiclib.queue[#musiclib.queue+1] = {url}
end

function musiclib.joinVC(voiceChannel)
    botVoiceChannelId = voiceChannel.id
    conn = voiceChannel:join(voiceChannel)
end

function musiclib.leaveVC()
    if conn then
        conn:close()
    end    
end

return musiclib