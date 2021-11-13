command.Register("meme", "Uses Reddit to get a random meme from a variety of subreddits.","fun",function(msg, args)
    --if command.Cooldown(msg, "meme", 2, "Calm down on the memes, wait **%s** seconds dude") then return end
    local subreddits = {
        "https://www.reddit.com/r/meme/hot/.json?limit=100",
        "https://www.reddit.com/r/technicallythetruth/hot/.json?limit=100",
        "https://www.reddit.com/r/me_irl/hot/.json?limit=100",
        "https://www.reddit.com/r/softwaregore/hot/.json?limit=100",
        "https://www.reddit.com/r/madlads/hot/.json?limit=100",
        "https://www.reddit.com/r/wholesomememes/hot/.json?limit=100",
        "https://www.reddit.com/r/facepalm/hot/.json?limit=100",

    }
    function sendMeme()
        local subreddit = subreddits[math.random(#subreddits)]
        local res, data = CORO.request("GET", subreddit)
        local body = JSON.parse(data)
        local image = body["data"]["children"][math.random(1, 100)]["data"]
        local imgurl = image.url
        local imgtitle = image.title
        msg:reply({
            embed = {
              title = imgtitle,
              url = "https://www.reddit.com"..image.permalink,
              image = {url =  imgurl},
              color = EMBEDCOLOR,
              timestamp = DISCORDIA.Date():toISO('T', 'Z')
              }
          })
        end
        if pcall(sendMeme) then
            -- meme send
        else
            msg:reply("Error getting meme, please try again!")
        end
end)