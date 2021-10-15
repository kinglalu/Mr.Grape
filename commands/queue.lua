-- Bruh don't use 2 space indent

command.Register("queue", "See the queue of the music playing!", "music", function(msg, args)

embed = {
  title = msg.guild.name .. "'s Queue",
  description = "**__Now playing:__** joe",
  fields = {},
  footer = {
    text = "1 of 1"
  },
  color = DISCORDIA.Color.fromRGB(170, 26, 232).value,
  timestamp = DISCORDIA.Date():toISO('T', 'Z')
}

--[[
{name = "**1) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
{name = "**2) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
{name = "**3) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
{name = "**4) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
{name = "**5) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
{name = "**6) SONG NAME**", value = "`0:00` **|** ".."<@"..msg.author.id..">", inline = false},
--]]



msg:reply(embed)
end)