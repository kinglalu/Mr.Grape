command.Register("cat", "Get a random cat image!","fun",function(msg, args)
    --if command.Cooldown(msg, "cat", 2, "Look, ik cats are cute, but  wait **%s** seconds dude") then return end
    local res, data = CORO.request("GET", "https://api.thecatapi.com/v1/images/search?limit=1&size=full&mime_types=jpg,png")
    local image = JSON.parse(data)
    msg:reply({
        embed = {
          title = ":cat: Meow!",
          image = {url =  image[1]["url"]},
          color = EMBEDCOLOR,
          timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
      })
end)