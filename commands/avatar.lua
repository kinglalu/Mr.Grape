command.Register("avatar", "Get a user's avatar","utility",function(msg, args)
  local person = command.FirstMention(msg)
  
  msg:reply({
    embed = {
      title = person.name .. "'s Avatar",
      image = {url =  person:getAvatarURL(256, 'png')},
      fields = {
          {name = 'ㅤ', value = '[PNG]('..person:getAvatarURL(1024, 'png')..')', inline = true},
          {name = 'ㅤ', value = '[JPG]('..person:getAvatarURL(1024, 'jpg')..')', inline = true},
          {name = 'ㅤ', value = '[WEBP]('..person:getAvatarURL(1024, 'webp')..')', inline = true},
        },
      color = DISCORDIA.Color.fromRGB(170, 26, 232).value,
      timestamp = DISCORDIA.Date():toISO('T', 'Z')
      }
  })
end)
  