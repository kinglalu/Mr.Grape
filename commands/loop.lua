command.Register("loop", "loop the song","music", function(msg, args)
    if msg.member.voiceChannel and MUSIC.isPlaying then
        MUSIC.loop = not MUSIC.loop
        msg:reply((MUSIC.loop and "Started loop" or "Ended loop"))
    end
end)