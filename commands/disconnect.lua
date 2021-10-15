command.Register("dc", "Have Mr Grape leave the vc","music", function(msg, args)
    MUSIC.leaveVC(msg.member.voiceChannel)
end)