command.Register("queue", "See the queue of the music playing!", "music", function(msg, args)
    --[[
    {name = "**1) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**2) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**3) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**4) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**5) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
    {name = "**6) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
	--]]
	print(#MUSIC.queue)
	print(FUNCTIONS.print_table(MUSIC.queue))
	if #MUSIC.queue > 0 then
		local embed = {
			title = msg.guild.name .. "'s Queue",
			-- should be name instead
			description = "**__Now playing:__** " .. "[" .. MUSIC.queue.title[1] .. "](" .. MUSIC.queue[2] .. ')',
			fields = {},
			footer = {
				text = "1 of 1",
			},
			color = EMBEDCOLOR,
			timestamp = DISCORDIA.Date():toISO('T', 'Z')
		} 
		for i = 2, #args do
			table.insert(embed.fields, {
				name = MUSIC.queue[i].title,
				value = MUSIC.queue[i].url,
				inline = true
			})
        end
		msg:reply{embed = embed}
	else
		msg:reply("There is nothing in the queue.")
	end
end)