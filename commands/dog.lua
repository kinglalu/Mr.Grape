command.Register("dog", "Get a random dog image!","fun",function(msg, args)
    --if command.Cooldown(msg, "dog", 2, "Look, ik dogs are cute, but  wait **%s** seconds dude") then return end
    local res, data = CORO.request("GET", "https://api.thedogapi.com/v1/images/search?limit=1&size=full&mime_types=jpg,png")
    local image = JSON.parse(data)
    msg:reply({
        embed = {
          title = ":dog: Woof!",
          image = {url =  image[1]["url"]},
          color = DISCORDIA.Color.fromRGB(170, 26, 232).value,
          timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
      })
end)