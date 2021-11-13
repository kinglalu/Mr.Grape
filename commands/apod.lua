command.Register("apod", "Sends Nasa's pic of the day","fun",function(msg, args)
    local res, data = CORO.request("GET", "https://api.nasa.gov/planetary/apod?api_key="..CONFIG.apodkey)
    local image = JSON.parse(data)
    msg:reply({
        embed = {
          title = "NASA's Picture of the Day!",
          description = image["explanation"],
          image = {url =  image["hdurl"]},
          color = EMBEDCOLOR,
          timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
      })
end)