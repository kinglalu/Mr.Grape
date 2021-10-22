command.Register("cat", "Get a random cat image!","fun",function(msg, args)
    local res, data = CORO.request("GET", "https://api.thecatapi.com/v1/images/search")
    local key,value = unpack(res)
    local datvar = string.split((tostring(data)),'"')
    -- url is datvar[10]
    msg:reply({
        embed = {
          title = ":cat: Meow!",
          image = {url =  datvar[10]},
          color = DISCORDIA.Color.fromRGB(170, 26, 232).value,
          timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
      })
end)