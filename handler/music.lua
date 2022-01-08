local timer = require('timer')
-- Replace url.lua with this
local fs = require('fs')
local parse = require("url").parse
local json = require("json")

local Music,get = require('discordia/libs/class')('Music')

local instances = {}

function Music.Instance(guild, is_temp)
	if instances[guild.id] == nil then
		if is_temp then return Music(guild) end
		instances[guild.id] = Music(guild)
	end
	
	return instances[guild.id]
end

function Music:__init(guild)
	self._nowPlaying = ""
	self._guild = guild
	self._bitrate = 96000
	self._isPaused = false;
	self._isPlaying = false
	self._queue = {}
    self._botVoiceChannelId = nil
end



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

-- Library

CLIENT:on("voiceChannelLeave", function(member, channel)
	local M = Music.Instance(member.guild)
	
    if M._botVoiceChannelId == channel.id and #channel.connectedMembers == 1 then
        print("The bot is alone")
        -- Disconnect from VC after 5 minutes
        -- timer.setTimeout(300000, M:leaveVC())
    end
end)

function Music:addSong(query)
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
	
	if process == nil then return nil end
    
    local parts = {}
    for part in process.stdout.read do
        parts[#parts + 1] = part
    end
    local output = table.concat(parts, '')
    fs.writeFile("log/output.json", output)

    if output == '' then
        return "Unable to get json"
    else
        if pcall(function () self._json = json.parse(output) end) then
            self:queueAdd(self._json.title, self._json)
        else
            return "Unable to fetch video information, most likely a yt-dlp bug. Create an issue if one doesn't exist or tell a mr grape developer."
        end
    end
end

function Music:queueAdd(title, json)
	-- self._queue[#self._queue + 1] = {
	table.insert(self._queue, {
		title = title,
		json = json
	})
end

function Music:play(msg)
    if (#self.queue > 0) then
        self._nowPlaying = "**__Now playing:__** " .. '**['..self._queue[1].title..']'..'('..self._queue[1].json.webpage_url..')**'

        msg:reply({
            embed = {
            title = "Now Playing",
            thumbnail = {url =  self._queue[1].json.thumbnails[#self._queue[1].json.thumbnails].url},
            description = self._nowPlaying,
            color = EMBEDCOLOR,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
            }
        })

        coroutine.wrap(function()
            if self._conn then
                self._conn:setBitrate(self._bitrate)
                self._conn:setComplexity(10)
            end
            if (pcall(function() self._conn:playFFmpeg(self._queue[1].json.formats[6].url, 108000000) end)) then
                print("Song over")
                self:play(msg)
            end
        end)()

        if not loop then
            print("REMOVING")
            table.remove(self._queue, 1)
        end
    end
end

function Music:toggle(query, msg)
    if self._isPaused then
        self._conn:resumeStream()
        self._isPaused = false
    else
        self._conn:pauseStream()
        self._isPaused = true
    end
end

function Music:joinVC(voiceChannel)
    self._isPlaying = true
    self._botVoiceChannelId = voiceChannel.id
    self._conn = voiceChannel:join(voiceChannel)
end

function Music:leaveVC()
    -- Cleanup variables
    self._nowPlaying = nil
    self._botVoiceChannelId = nil
    self._isPaused = false
    self._queue = {}

    if self._isPlaying == true then
        self._isPlaying = false
        self._conn:close()
        self._conn = nil
    end
	
	instances[self.guild.id] = nil
end

return Music