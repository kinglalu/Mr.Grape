command.Register("userinfo", "Get info about a user","utility",function(msg, args)
  local person = command.FirstMention(msg)

  
  msg:reply({
    embed = {
     title = person.name.."'s UserInfo",
      thumbnail = {url = person:getAvatarURL(64, 'png')},
      fields = {
        {name = 'Name', value = '<@' .. person.id .. '>', inline = true},
        {name = 'Discriminator', value = person.discriminator, inline = true},
        {name = 'ID', value = person.id, inline = true},
        {name = 'Highest Role', value = '<@&' .. person.highestRole.id .. '>', inline = true},
        {name = 'Joined Server', value = person.joinedAt and person.joinedAt:gsub('%..*', ''):gsub('T', ' '), inline = true},
        {name = 'Joined Discord', value = DISCORDIA.Date.fromSnowflake(person.id):toISO(' ', ''), inline = true},
      },
      color = EMBEDCOLOR,
      timestamp = DISCORDIA.Date():toISO('T', 'Z')
    }
  })
end)