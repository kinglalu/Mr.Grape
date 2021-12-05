command.Register("play", "play music with Mr Grape!","music", function(msg, args)
    if not args[1] then
        msg.channel:send("A song is needed.")
    elseif msg.member.voiceChannel then
        MUSIC.msg = msg

        local query = ''
        for i = 1, #args do
            query = query .. (i == 1 and '' or ' ') .. args[i]
        end

        local isPlaying = MUSIC.isPlaying

        MUSIC.joinVC(msg.member.voiceChannel)

        local err = MUSIC.addSong(query)
        if err then
            msg:reply(err)
        else
            if isPlaying then
                msg:reply({
                    embed = {
                    title = "Added to queue",
                    thumbnail = {url =  MUSIC.json.thumbnails[#MUSIC.json.thumbnails].url},
                    description = '**['..MUSIC.queue[#MUSIC.queue].title..']'..'('..MUSIC.queue[#MUSIC.queue].json.webpage_url..')**',
                    color = EMBEDCOLOR,
                    timestamp = DISCORDIA.Date():toISO('T', 'Z')
                }})
            else
                MUSIC.play()
            end
        end
    else
        msg.channel:send("You are not in a voice channel.")
    end
end)