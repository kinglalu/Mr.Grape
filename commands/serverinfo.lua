command.Register("serverinfo", "displays server info","utility",function(msg, args)
       local server = msg.guild
   --[[  local embed = {
        thumbnail = {url = guild.icon},
            fields = {
                  {name = 'Server Owner', value = guild.owner, inline = true},
                  {name = 'ID', value = guild.id, inline = true},
                  {name = 'Member Count', value = guild.totalMemberCount, inline = true},
                  {name = 'Creation Date', value = guild.createdAt, inline = true},
                  {name = 'Number of users boosting', value = guild.premiumSubscriptionCount, inline = true},
                  {name = 'Server Region', value = guild.Region, inline = true},
        }
} ]]--
      assert(msg:reply{
            embed = {
                  title = server.name.."'s server info",
                  thumbnail = {url = server.iconURL},
                  fields = {
                    {name = "Server Owner", value = server.owner.mentionString, inline = true},
                    {name = "ID", value = server.id, inline = true},
                    {name = "Member Count", value = server.totalMemberCount, inline = true},
                    {name = "Creation Date", value = DISCORDIA.Date().fromSnowflake(server.id):toISO(' ', ''), inline = true},
                    {name = 'Categories', value = tostring(#server.categories), inline = true},
                    {name = 'Text Channels', value = tostring(#server.textChannels), inline = true},
                    {name = 'Voice Channels', value = tostring(#server.voiceChannels), inline = true},
                    {name = 'Roles', value = tostring(#server.roles), inline = true},
                    {name = 'Emojis', value = tostring(#server.emojis), inline = true},
                    {name = "Number Of Users boosting", value = server.premiumSubscriptionCount, inline = true},
                    {name = "Server Region", value = server.region, inline = true},
                  },
                color = DISCORDIA.Color.fromRGB(170, 26, 232).value,
                timestamp = DISCORDIA.Date():toISO('T', 'Z')
                }     
      })
end)

