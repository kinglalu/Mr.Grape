command.Register("joke", "Get a random joke!","fun",function(msg, args)
    --if command.Cooldown(msg, "joke", 2, "I know you love my jokes, but  wait **%s** seconds dude") then return end
    local res, data = CORO.request("GET", "https://v2.jokeapi.dev/joke/Any?blacklistFlags=nsfw,religious,political,racist,sexist,explicit&type=twopart")
    local joke = JSON.parse(data)
    
    msg:reply({
        embed = {
          title = "Joke:",
          description = joke["setup"],
          fields = {
            {name = "ㅤ", value = joke["delivery"] }
          },
          color = DISCORDIA.Color.fromRGB(170, 26, 232).value,
          timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
      })
end)