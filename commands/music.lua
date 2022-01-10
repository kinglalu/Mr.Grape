local Music = require('../handler/music.lua')

command.Register("play", "play music with Mr Grape!","music", function(msg, args)
	local M = Music.Instance(msg.guild, false)
	
	if not args[1] then
		msg.channel:send("A song is needed.")
		return nil
	elseif not msg.member.voiceChannel then
		msg.channel:send("You're not in a voice channel.")
		return nil
	end
	
	local query = ''
	for i = 1, #args do
		query = query .. (i == 1 and '' or ' ') .. args[i]
	end
	
	local reply = msg:reply('Searching for the song...');
	
	M:addSong(query, msg.author.id, function(errmsg, data)
		if errmsg then
			reply:_modify({
				content = 'Encountered an error:\n' .. errmsg
			})
			return nil
		end
		
		if not M._nowPlaying then
			M:play()
		end
		
		reply:_modify({
			content = 'Found!',
			embed = {
				title = "Added to queue",
				thumbnail = {url =  data.thumbnails[#M._nowPlaying.thumbnails].url},
				description = '**['..data.title..']'..'('..data.webpage_url..')**',
				color = EMBEDCOLOR,
				timestamp = DISCORDIA.Date():toISO('T', 'Z'),
			},
		})
		
		M:joinVC(msg.member.voiceChannel)
	end)
end)

command.Register("nowplaying", "find out what song is playing", "music", function(msg, args)
	local M = Music.Instance(msg.guild, true)
	
	 if M._nowPlaying ~= nil then
		 msg:reply({
			embed = {
				title = "Now Playing",
				thumbnail = {url =  M._nowPlaying.thumbnails[#M._nowPlaying.thumbnails].url},
				-- add duration
				description = '**['..M._nowPlaying.title..']'..'('..M._nowPlaying.webpage_url..')**',
				color = EMBEDCOLOR,
				timestamp = DISCORDIA.Date():toISO('T', 'Z')
			}
		})
	else
        msg.channel:send("You're not in a voice channel.")
    end
end)

command.Register("skip", "skip the song that is playing","music", function(msg, args)
	local M = Music.Instance(msg.guild, true)
	
	if msg.member.voiceChannel then
        -- TODO: Allow the user to specify how many songs to skip
        if #M._queue >= 1 then
            M:play()
        else
			msg.channel:send("There are no songs left in the queue.")
		end
    else
        msg.channel:send("You're not in a voice channel.")
    end
end)

command.Register("pause", "Pause the music.","music", function(msg, args)
	local M = Music.Instance(msg.guild, true)
	
	if #M._queue > 0 then
		if not M._isPaused then
			M:toggle()
			msg:reply("Paused.")
		else
			msg:reply("You're not playing music.")
		end
	else
		msg:reply("You're not playing music.")
	end
end)

command.Register("resume", "Pause the music.","music", function(msg, args)
	local M = Music.Instance(msg.guild, true)
	
	if #M._queue > 0 then
		if M._isPaused then
			M:toggle()
			msg:reply("Resumed.")
		else
			msg:reply("You're already playing music!")
		end
	else
		msg:reply("You're not playing music!")
	end
end)

command.Register("queue", "See the queue of the music playing!", "music", function(msg, args)
    local M = Music.Instance(msg.guild, true)
	
	if M._nowPlaying ~= nil then
		local embed = {
			title = msg.guild.name .. "'s Queue",
			-- should be name instead
			description = "**__Now playing:__** " .. '**['..M._nowPlaying.title..']'..'('..M._nowPlaying.webpage_url..')**',
			footer = {
				text = "1 of 1",
			},
			color = EMBEDCOLOR,
			timestamp = DISCORDIA.Date():toISO('T', 'Z')
		}
		
		for i,song in pairs(M._queue) do
			embed.description = embed.description .. "\n\n"
				.. "**" .. i .. ") ["..song.title.."]("..song.webpage_url..")**\n"
				.. "`" .. song.duration_string .. "`|<@" .. song.requester .. ">"
        end
		msg:reply{embed = embed}
	else
		msg:reply("You're not playing music.")
	end
end)