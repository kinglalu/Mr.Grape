command.Register("skip", "skip the song that is playing","music", function(msg, args)
    if msg.member.voiceChannel then
        -- TODO: Allow the user to specify how many songs to skip
        if (#MUSIC.queue >= 1) then
            MUSIC.play()
        end
    else
        msg.channel:send("You are not in a voice channel.")
    end
end)