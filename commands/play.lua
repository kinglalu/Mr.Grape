command.Register("play", "play music with Mr Grape!","music", function(msg, args)
    MUSIC.joinVC(msg.member.voiceChannel)
end)