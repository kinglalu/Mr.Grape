local DB = require('../handler/items.lua')

command.Register('items', 'See your items', 'economy', function(msg, args)
	local person = command.FirstMention(msg)
	local id = DB.CreateRowUser(person)
	local items = DB.GetUserItems(id)
	local embed = {
		title = person.name.."'s Items",
		fields = {},
		color = EMBEDCOLOR,
        timestamp = DISCORDIA.Date():toISO('T', 'Z')
	}
	
	for i,v in pairs(items) do
		table.insert(embed.fields, {name=i..'(s)',value=v.quantity})
	end
	assert(msg:reply{embed = embed})
	
end)
--[[
command.Register('debug-add-apples', 'debug command', 'economy', function(msg, args)
	local id = DB.CreateRowUser(msg.author)
	local items = DB.GetUserItems(id)
	
	items.Apple.quantity = items.Apple.quantity + 5
	
	DB.SetUserItems(id, items)
	
	msg:reply('Ok.')
end)
--]]
command.Register('reset', 'developer only command', 'economy', function(msg, args)
	if msg.author.id == 329331044828446722 or 792347503960915968 then
	local person = command.FirstMention(msg)
	local id = DB.CreateRowUser(person)
    local stars = DB.GetUserStars(id)
	local items = DB.GetUserItems(id)
	items = {}
	DB.SetUserItems(id,items)
	
	stars = 0
	DB.SetUserStars(id, stars)
	msg:reply('Ok.')
	else msg:reply("not developer")
	end
end)

--[[
command.Register('debug-test-apples', 'debug command', 'economy', function(msg, args)
	local id = DB.CreateRowUser(msg.author)
	local items = DB.GetUserItems(id)
	
	if items.Apple then
		msg:reply('You have '..items.Apple.quantity ..' apples')
	else
		msg:reply('You have no apples.')
	end
end)

command.Register('debug-have-apples', 'debug command', 'economy', function(msg, args)
	local id = DB.CreateRowUser(msg.author)
	local items = DB.GetUserItems(id)
	
	if not items.Apple then
		msg:reply('You have no apples.')
	else
		msg:reply('You have'..items.Apple.quantity..' apples.')
	end
end) --]]