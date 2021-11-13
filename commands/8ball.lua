local answers = {
  'Better not tell you now.',
  'Don’t count on it.',
  'It is certain.',
  'It is decidedly so.',
  'Most likely.',
  'My reply is no.',
  'My sources say no.',
  'Outlook not so good.',
  'Outlook good.',
  'Signs point to yes.',
  'Very doubtful.',
  'Without a doubt.',
  'Yes.',
  'Yes – definitely.',
  'You may rely on it.',
  'Ah my bad, I missed that, can you repeat that?'
}

command.Register("8ball", "Have Mr Grape give some advice!","fun",function(msg, args)
  local response = answers[math.random(1, #answers)]
  
  if #args == 0 then
    msg.channel:send("Please ask a question!")
  else
    msg:reply({
      embed = {
        title = ":8ball: Magic Ball",
        description = "Question:\n"..msg.content:gsub(PREFIX .. "8ball ", ""),
        fields = {
          {name = "Answer:", value = response }
        },
        color = EMBEDCOLOR,
        timestamp = DISCORDIA.Date():toISO('T', 'Z')
      }
    })
  end
end)