-- Bruh don't use 2 space indent

command.Register("queue", "See the queue of the music playing!", "music", function(msg, args)
    --[[
    {name = "**1) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**2) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**3) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**4) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**5) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**6) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    --]]
	if MUSIC.queue[1][1] then
		msg:reply({
			embed = {
				title = msg.guild.name .. "'s Queue",
				description = "**__Now playing:__** ".. MUSIC.queue[1][1],
				fields = {},
				footer = {
					text = "1 of 1",
				},
				color = DISCORDIA.Color.fromRGB(170, 26, 232).value,
				timestamp = DISCORDIA.Date():toISO('T', 'Z')
			}
		})
	else
		msg:reply("There is nothing in the queue.")
	end
end)