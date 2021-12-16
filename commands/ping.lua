command.Register("ping","Your basic ping command!","utility", function(msg, args)
	msg.channel:send("Pong!")
end)