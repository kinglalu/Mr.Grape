local DB = require('../db')

--[[
TABLE Items
{
	"item name": {
		"quantity": 0 (Int)
	}
}
]]--

local KnownItems = {
	Apple = {
		Emoji = ":apple:"
	}
}

-- ID from CreateUserRow
function DB.GetUserItems(id)
	local db_items = DB.db:rowexec('SELECT items FROM users WHERE id = "' .. id .. '"')
	local items = JSON.parse(db_items)
	
	for i,v in pairs(items) do
		if not KnownItems[i] or not v.quantity or v.quantity == 0 then
			Items[i] = nil
		end
	end
	
	return items
end

-- ID from CreateUserRow
function DB.SetUserItems(id, items)
	local stmt = DB.db:prepare[[
		UPDATE users SET items = ? WHERE id = ?
	]]
	
	stmt:bind(JSON.stringify(items), id)
	stmt:step()
	
	return items
end

command.Register('items', 'See your items', 'economy', function(msg, args)
	local id = DB.CreateRowUser(msg.author.id)
	local items = DB.GetUserItems(id)
	local embed = {
		title = "Items",
		fields = {},
		color = DISCORDIA.Color.fromRGB(170,26,232).value,
        timestamp = DISCORDIA.Date():toISO('T', 'Z')
	}
	
	for i,v in pairs(items) do
		table.insert(embed.fields, {name=i..'(s)',value=v.quantity})
	end
	assert(msg:reply{embed = embed})
	
end)

command.Register('debug-add-apples', 'See your items', 'economy', function(msg, args)
	local id = DB.CreateRowUser(msg.author.id)
	local items = DB.GetUserItems(id)
	
	items.Apple.quantity = items.Apple.quantity + 5
	
	DB.SetUserItems(id, items)
	
	msg:reply('Ok.')
end)

command.Register('debug-erase-apples', 'See your items', 'economy', function(msg, args)
	local id = DB.CreateRowUser(msg.author.id)
	local items = DB.GetUserItems(id)
	
	items.Apple = nil
	
	DB.SetUserItems(id, items)
	
	msg:reply('Ok.')
end)

command.Register('debug-test-apples', 'See your items', 'economy', function(msg, args)
	local id = DB.CreateRowUser(msg.author.id)
	local items = DB.GetUserItems(id)
	
	if items.Apple then
		msg:reply('You have '..items.Apple.quantity ..' apples')
	else
		msg:reply('You have no apples.')
	end
end)

command.Register('debug-have-apples', 'See your items', 'economy', function(msg, args)
	local id = DB.CreateRowUser(msg.author.id)
	local items = DB.GetUserItems(id)
	
	if not items.Apple then
		msg:reply('You have no apples.')
	else
		msg:reply('You have'..items.Apple.quantity..' apples.')
	end
end)