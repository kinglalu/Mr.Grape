command.Register("ping", "utility", function(msg, args)
	msg.channel:send("Pong!")
end)