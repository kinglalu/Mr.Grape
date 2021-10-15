command.Register("ban", "Ban users in your server, requires you to have ban members permission","moderation", function(msg, args)
	local author = msg.guild:getMember(msg.author.id)
    local member = msg.mentionedUsers.first
    if not member then
        msg:reply("Please mention someone to ban!")
        return
      elseif not author:hasPermission("banMembers") then
        msg:reply("You don't have permission to ban people bro")
        return
      elseif member == author then
      msg:reply("You can't ban yourself!")
      end
      for user in msg.mentionedUsers:iter() do
        member = msg.guild:getMember(user.id)
        if author.highestRole.position > member.highestRole.position then
          msg:reply("Member Banned!")
          member:ban()
        else
          msg:reply("A occur occured trying to ban, either that person is an admin/mod, or I don't have permission to ban.")
        end
    end
end)