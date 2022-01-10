local util = require("../lib/util.lua")
local coro_spawn = require('coro-spawn')
-- Replace url.lua with this
local fs = require('fs')
local parse = require("url").parse
local json = require("json")

local Music,get = require('discordia/libs/class')('Music')

local instances = {}

CLIENT:on("voiceChannelLeave", function(member, channel)
	local M = Music.Instance(member.guild)
	
    if M._botVoiceChannelId == channel.id and #channel.connectedMembers == 1 then
        print("The bot is alone")
        -- Disconnect from VC after 5 minutes
        -- timer.setTimeout(300000, M:leaveVC())
    end
end)

function Music.Instance(guild, is_temp)
	if instances[guild.id] == nil then
		if is_temp then return Music(guild) end
		instances[guild.id] = Music(guild)
	end
	
	return instances[guild.id]
end

function Music:__init(guild)
	self._guild = guild
	self._bitrate = 96000
	self._isPaused = false
	self._isConnected = false
	self._queue = {}
    self._botVoiceChannelId = nil
	self._nowPlaying = nil
end

-- returns type() string if an error occured
-- returns type() table if the data was successfully retrieved
-- callback = function(errmsg, err)
function Music:addSong(query, requester, callback)
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
		callback("Unable to launch YTDL.", nil)
    end
	
	coroutine.wrap(function()
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
				duration_string = parsed.duration_string,
				requester = requester,
			}
			errmsg = nil
		end)
		
		if errmsg == nil and data == nil then
			errmsg = "An unknown error occured."
		end
		
		if data ~= nil then
			table.insert(self._queue, data)
		end

		callback(errmsg, data)
	end)()
end


function Music:play()
    if (#self._queue > 0) then
		self._nowPlaying = self._queue[1]
		
        coroutine.wrap(function()
			self._conn:setBitrate(self._bitrate)
			self._conn:setComplexity(10)
			
			if not loop then
				table.remove(self._queue, 1)
			end
			
			if (pcall(function() self._conn:playFFmpeg(self._nowPlaying.formats[6].url, 108000000) end)) then
				self._nowPlaying = nil
				
				if not loop then
					table.remove(self._queue, 1)
				end
				
				-- print("Song over")
				self:play()
			else
				print('Error starting FFmpeg in pcall...');
            end
        end)()
    else
		self._nowPlaying = nil
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
    self._botVoiceChannelId = nil
	self._nowPlaying = nil
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