command.Register("ping","Your basic ping command!","utility", function(msg, args)
	local time1 = msg.createdAt
	local msg2 = msg.channel:send{
        embed = {
            title = "Pong!",
            description = "Getting ping...",
            color = EMBEDCOLOR,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
    }
	local time2 = msg2.createdAt
	local ping = string.sub(tostring(time2-time1), 4, 6)
	print(ping)
	ping = string.sub(ping, 1, 1)..'.'..string.sub(ping,2,6)
	local pe = {
		title =  "Pong!",
		description = 'Ping: ``'..ping..'ms``',
		color = EMBEDCOLOR,
		timestamp = DISCORDIA.Date():toISO('T', 'Z')
	}
	msg2:setEmbed(pe)
	
end)