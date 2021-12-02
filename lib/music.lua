local timer = require('timer')
-- Replace url.lua with this
local musiclib = {}
local parse = require("url").parse
local json = require("json")

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
local botVoiceChannelId
local isPaused

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
    args = {}
    if parse(query).hostname == "www.youtube.com" or parse(query).hostname == "youtu.be" then
        print("Not searching")
        args = { "--dump-json", query }
    else
        print("Searching")
        args = { "--dump-json", "--playlist-end", "1", "ytsearch:\"" .. query .. "\"" }
    end

    local process = require("coro-spawn")("yt-dlp", {
        args = args,
        stdio = { nil, true, 2 }
    })
    
    for output in process.stdout.read do
        print(json.parse(output))
        musiclib.json = json.parse(output)
    end


    musiclib.queueAdd(musiclib.json.title, musiclib.json.formats[1].url)
    conn = msg.member.voiceChannel:join()
    
    msg:reply({
        embed = {
          title = "Now Playing",
          thumbnail = {url =  musiclib.json.thumbnails[#musiclib.json.thumbnails].url},
          description = '**['..musiclib.json.title..']'..'('..musiclib.json.webpage_url..')**',
          color = EMBEDCOLOR,
          timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
    })

    conn:playFFmpeg(musiclib.json.formats[1].url)
end

function musiclib.toggle(query, msg)
    if isPaused then
        conn:resumeStream()
        isPaused = false
    else
        conn:pauseStream()
        isPaused = true
    end
end

function musiclib.queueAdd(title, url)
    print(title)
    print(url)
    musiclib.queue[#musiclib.queue + 1] = {
        title = query,
        url = url
    }
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