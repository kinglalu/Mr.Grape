command.Register("invite", "Sends an invite of the bot to add to your server","utility",function(msg, args)
	msg:reply{
        embed = {
            title = "Add Mr Grape!",
            fields = {
              {name = "Bot Invite", value = '[Add it to your server!](https://discord.com/oauth2/authorize?client_id=884247238291890236&scope=bot&permissions=8)', inline = true},
              {name = "Support Server", value = '[Join the Mr Grape Community!](https://discord.gg/2RKPmDg2A6)', inline = true},
              {name = "ㅤ", value = NODECLUSTERS, inline = false},
            },
            color = EMBEDCOLOR,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
    }
end)