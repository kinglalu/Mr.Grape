command.Register("fact", "Get a random fact!","fun",function(msg, args)
    --if command.Cooldown(msg, "joke", 2, "I know these facts are intresting, but  wait **%s** seconds dude") then return end
    local res, data = CORO.request("GET", "https://useless-facts.sameerkumar.website/api")
    local fact = JSON.parse(data)
    
    msg:reply({
        embed = {
          title = "Fact",
          description = fact["data"],
          color = DISCORDIA.Color.fromRGB(170, 26, 232).value,
          timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
      })
end)