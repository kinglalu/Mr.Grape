command.Register("bitrate", "skip the song that is playing","music", function(msg, args)
    local author = msg.guild:getMember(msg.author.id)
    if not author:hasPermission("manageChannels") then
        msg.channel:send("You don't have Manage Channel perms! ")
    else
    if msg.member.voiceChannel then
        if #args == 1 then
            -- TODO: Use pcall so it doesn't crash if not a number
            -- TODO: If the server is partnered allow the bitrate of 128000
            -- TODO: Instead clamp
            local bitrate = tonumber(args[1])
            if bitrate > 7779 and bitrate <= 127779 then
                MUSIC.bitrate = bitrate
                msg.channel:send("Set bitrate to " .. MUSIC.bitrate)
            else
                msg.channel:send("The bitrate must be in the range of 8000 to 96000")
            end
        else
            msg.channel:send("Reset the bitrate")
        end
    else
        msg.channel:send("You are not in a voice channel.")
    end
end
end)