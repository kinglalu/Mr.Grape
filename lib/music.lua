local timer = require('timer')
-- Replace url.lua with this
local musiclib = {}
local fs = require('fs')
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

local msg
local nowPlaying
local botVoiceChannelId
local isPaused

-- Library

CLIENT:on("voiceChannelLeave", function(member, channel)
    if botVoiceChannelId == channel.id and #channel.connectedMembers == 1 then
        print("The bot is alone")
        -- Disconnect from VC after 5 minutes
        -- timer.setTimeout(300000, musiclib.leaveVC())
    end
end)

musiclib.queue = {}

function musiclib.addSong(query)
    args = {}
    -- TODO: Use tenary
    if parse(query).hostname == "www.youtube.com" or parse(query).hostname == "youtu.be" then
        print("Not searching")
        args = { "--dump-json", "--no-playlist", "--verbose", query }
    else
        print("Searching")
        args = { "--dump-json", "--no-playlist", "--verbose", "--playlist-end", "1", "ytsearch:\"" .. query .. "\"" }
    end

    local process = require("coro-spawn")("yt-dlp", {
        args = args,
        stdio = { nil, true, 2 }
    })
    
    local parts = {}
    for part in process.stdout.read do
        parts[#parts + 1] = part
    end
    local output = table.concat(parts, '')
    fs.writeFile("log/output.json", output)

    if output == '' then
        return "Unable to get json"
    else
        if pcall(function () musiclib.json = json.parse(output) end) then
            musiclib.queueAdd(musiclib.json.title, musiclib.json)
        else
            return "Unable to fetch video information, most likely a yt-dlp bug. Create an issue if one doesn't exist or tell a mr grape developer."
        end
    end
end

function musiclib.queueAdd(title, json)
    print(title)
    print(json.formats[6].url)
    musiclib.queue[#musiclib.queue + 1] = {
        title = title,
        json = json
    }
end

musiclib.bitrate = 96000

function musiclib.play()
    if (#MUSIC.queue > 0) then
        musiclib.nowPlaying = "**__Now playing:__** " .. '**['..musiclib.queue[1].title..']'..'('..musiclib.queue[1].json.webpage_url..')**'

        musiclib.msg:reply({
            embed = {
            title = "Now Playing",
            thumbnail = {url =  musiclib.queue[1].json.thumbnails[#musiclib.queue[1].json.thumbnails].url},
            description = musiclib.nowPlaying,
            color = EMBEDCOLOR,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
            }
        })

        coroutine.wrap(function()
            if musiclib.conn then
                musiclib.conn:setBitrate(musiclib.bitrate)
                musiclib.conn:setComplexity(10)
            end
            if (pcall(function() musiclib.conn:playFFmpeg(musiclib.queue[1].json.formats[6].url, 108000000) end)) then
                print("Song over")
                musiclib.play()
            end
        end)()

        if not loop then
            print("REMOVING")
            table.remove(musiclib.queue, 1)
        end
    end
end

function musiclib.toggle(query, msg)
    if isPaused then
        musiclib.conn:resumeStream()
        isPaused = false
    else
        musiclib.conn:pauseStream()
        isPaused = true
    end
end

musiclib.isPlaying = false

function musiclib.joinVC(voiceChannel)
    musiclib.isPlaying = true
    botVoiceChannelId = voiceChannel.id
    musiclib.conn = voiceChannel:join(voiceChannel)
end

function musiclib.leaveVC()
    -- Cleanup variables
    musiclib.nowPlaying = ""
    musiclib.botVoiceChannelId = nil
    musiclib.isPaused = false
    musiclib.queue = nil
    musiclib.queue = {}

    if musiclib.isPlaying == true then
        musiclib.isPlaying = false
        musiclib.conn:close()
        musiclib.conn = nil
    end
end

return musiclib