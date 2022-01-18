command.Register("kick", "kick users in your server, requires you to have kick members permission","moderation", function(msg, args)
	local author = msg.guild:getMember(msg.author.id)
    local member = msg.mentionedUsers.first
    if not member then
        msg:reply("Please mention someone to kick!")
        return
      elseif not author:hasPermission("kickMembers") then
        msg:reply("You don't have permission to kick people bro")
        return
      elseif member == author then
      msg:reply("You can't kick yourself!")
        return
      elseif not msg.guild:getMember(CLIENT.user.id):hasPermission("kickMembers") then
        msg:reply("I don't have permission to kick people.")
        return
      end
      for user in msg.mentionedUsers:iter() do
        member = msg.guild:getMember(user.id)
        if author.highestRole.position > member.highestRole.position then
          msg:reply("Member kicked!")
          member:kick()
        else
          msg:reply("A occur occured trying to kick, perhaps that person is an admin/mod.")
        end
    end
end)