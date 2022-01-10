local util = require("./lib/util.lua")
local coro_spawn = require('coro-spawn')
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
	self._isPaused = false
	self._isConnected = false
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

-- returns type() string if an error occured
-- returns type() table if the data was successfully retrieved
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

    local process = coro_spawn("yt-dlp", {
        args = args,
        stdio = { nil, true, 2 }
    })
	
	if process == nil then
		return "Unable to launch YTDL."
    end
	
	local data = nil
	local errmsg = nil
	
pcall(function ()
	local parts = {}
	for part in process.stdout.read do
		parts[#parts + 1] = part
	end
	
	local output = table.concat(parts, '')
	
	if output == '' then
		errmsg = "Couldn't read any JSON bytes"
		return nil
	end
	
	errmsg = "An error occured when parsing YTDL."
	local parsed = JSON.parse(output)
	
	errmsg = "An error occurred when extracting data from YTDL."
	data = {
		title = parsed.title,
		webpage_url = parsed.webpage_url,
		thumbnails = parsed.thumbnails,
		formats = parsed.formats,
	}
	errmsg = ""
end)
	
	if errmsg:len() > 0 then
		return errmsg
	end
	
	if data == nil then return "An unknown error occured." end
	
	self:queueAdd(data)
	return data
end

function Music:queueAdd(data)
	-- self._queue[#self._queue + 1] = {
	table.insert(self._queue, data)
end

function Music:play(msg)
    if (#self._queue > 0) then
        self._nowPlaying = "**__Now playing:__** " .. '**['..self._queue[1].title..']'..'('..self._queue[1].webpage_url..')**'

        msg:reply({
            embed = {
            title = "Now Playing",
            thumbnail = {url =  self._queue[1].thumbnails[#self._queue[1].thumbnails].url},
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
            if (pcall(function() self._conn:playFFmpeg(self._queue[1].formats[6].url, 108000000) end)) then
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
    self._isConnected = true
    self._botVoiceChannelId = voiceChannel.id
    self._conn = voiceChannel:join(voiceChannel)
end

function Music:leaveVC()
    -- Cleanup variables
    self._nowPlaying = nil
    self._botVoiceChannelId = nil
    self._isPaused = false
    self._queue = {}

    if self._isConnected == true then
        self._isConnected = false
        self._conn:close()
        self._conn = nil
    end
	
	instances[self.guild.id] = nil
end

return Music