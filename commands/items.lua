local DB = require('../handler/items.lua')

command.Register('items', 'See your items', 'economy', function(msg, args)
	local person = command.FirstMention(msg)
	local id = DB.CreateRowUser(person)
	local items = DB.GetUserItems(id)
	local embed = {
		title = person.name.."'s Items",
		description = "",
		color = EMBEDCOLOR,
        timestamp = DISCORDIA.Date():toISO('T', 'Z')
	}
	
	local last_i = nil
	
	for i,v in pairs(items) do
		last_i = i
		embed.description = embed.description .. DB.KnownItems[i].Emoji .. " " .. i .. ": " .. v.quantity.."\n"
	end
	
	if last_i == nil then
		if person == msg.member then
			embed.description = "You have no items."
		else
			embed.description = person.name .. " has no items."
		end
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

command.Register('hack', 'Developer only command', '', function(msg, args)
	if msg.author.id == 329331044828446722 or 792347503960915968 then
	local amount =	tonumber(args[1])
	local id = DB.CreateRowUser(msg.author)
    local stars = DB.GetUserStars(id)
	local items = DB.GetUserItems(id)
    if amount == nil or amount < 0 then
		msg:reply("not valid") else
			stars = amount
			DB.SetUserStars(id, stars)
			msg:reply('Ok.')
		end
	else msg:reply("not developer")

	end
end)


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
