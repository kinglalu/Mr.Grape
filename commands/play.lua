command.Register("play", "play music with Mr Grape!","music", function(msg, args)
    if not args[1] then
        msg.channel:send("A song is needed.")
    elseif msg.member.voiceChannel then
        query = ''
        for i = 1, #args do
            query = query .. args[i]
        end
        MUSIC.play(query, msg)
    else
        msg.channel:send("You are not in a voice channel.")
    end
end)