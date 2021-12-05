command.Register("queue", "See the queue of the music playing!", "music", function(msg, args)
    --[[
    {name = "**1) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**2) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**3) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**4) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**5) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**6) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
	--]]

	if MUSIC.nowPlaying then
		local embed = {
			title = msg.guild.name .. "'s Queue",
			-- should be name instead
			description = MUSIC.nowPlaying .. (MUSIC.loop and " :repeat:" or ''),
			fields = {},
			footer = {
				text = "1 of 1",
			},
			color = EMBEDCOLOR,
			timestamp = DISCORDIA.Date():toISO('T', 'Z')
		}
		for i = 1, #MUSIC.queue do
			table.insert(embed.fields, {
				name = i..")",
				value = '**['..MUSIC.queue[i].title..']'..'('..MUSIC.queue[i].json.webpage_url..')**',
				inline = false
			})
        end
		msg:reply{embed = embed}
	else
		msg:reply("You need to be playing songs.")
	end
end)