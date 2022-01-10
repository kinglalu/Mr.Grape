local Music = require('../handler/music.lua')

command.Register("play", "play music with Mr Grape!","music", function(msg, args)
	local M = Music.Instance(msg.guild, false)
	
	if not args[1] then
		msg.channel:send("A song is needed.")
		return nil
	elseif not msg.member.voiceChannel then
		msg.channel:send("You are not in a voice channel.")
		return nil
	end
	
	local query = ''
	for i = 1, #args do
		query = query .. (i == 1 and '' or ' ') .. args[i]
	end
	
	local reply = msg:reply('Searching for the song');
	
	local data = M:addSong(query)
	
	if type(data) == 'string' then
		reply:_modify({
			content = 'Encountered an error:\n' .. data
		})
		return nil
	end
	
	reply:_modify({
		content = 'Found!',
		embed = {
			title = "Added to queue",
			thumbnail = {url =  data.thumbnails[1].url},
			description = '**['..data.title..']'..'('..data.webpage_url..')**',
			color = EMBEDCOLOR,
			timestamp = DISCORDIA.Date():toISO('T', 'Z'),
		},
	})
	
	M:joinVC(msg.member.voiceChannel)
end)

command.Register("skip", "skip the song that is playing","music", function(msg, args)
	local M = Music.Instance(msg.guild, true)
	
	if msg.member.voiceChannel then
        -- TODO: Allow the user to specify how many songs to skip
        if (#M._queue >= 1) then
            M:play()
        else
			msg.channel:send("There are no songs in the queue.")
		end
    else
        msg.channel:send("You are not in a voice channel.")
    end
end)

command.Register("pause", "Pause the music.","music", function(msg, args)
	local M = Music.Instance(msg.guild, true)
	
	if M._nowPlaying ~= nil then
		if not M._isPaused then
			M:toggle()
			msg:reply("Paused.")
		else
			msg:reply("Not playing music!")
		end
	else
		msg:reply("Not playing music!")
	end
end)

command.Register("resume", "Pause the music.","music", function(msg, args)
	local M = Music.Instance(msg.guild, true)
	
	if M._nowPlaying ~= nil then
		if M._isPaused then
			M:toggle()
			msg:reply("Resumed.")
		else
			msg:reply("Already playing music!")
		end
	else
		msg:reply("Not playing music!")
	end
end)

command.Register("queue", "See the queue of the music playing!", "music", function(msg, args)
    local M = Music.Instance(msg.guild, true)
	--[[
    {name = "**1) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**2) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**3) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**4) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**5) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**6) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.aMUSIC.bitrateuthor.id..">", inline = false},
	--]]

	if M._nowPlaying ~= "nil" then
		local embed = {
			title = msg.guild.name .. "'s Queue",
			-- should be name instead
			description = M._nowPlaying .. (M._loop and " :repeat:" or ''),
			fields = {},
			footer = {
				text = "1 of 1",
			},
			color = EMBEDCOLOR,
			timestamp = DISCORDIA.Date():toISO('T', 'Z')
		}
		
		for i = 1, #(M._queue) do
			table.insert(embed.fields, {
				name = i..")",
				value = '**['..M._queue[i].title..']'..'('..M._queue[i].webpage_url..')**',
				inline = false
			})
        end
		msg:reply{embed = embed}
	else
		msg:reply("You need to be playing songs.")
	end
end)