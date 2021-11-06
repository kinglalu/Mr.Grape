local DB = require('../DB')

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
		if not KnownItems[i] then
			Items[i] = nil
		end
		
		if not v.quantity then
			v.quantity = 0
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
	
	msg:reply {
        embed = {
            title = msg.author.name .. "'s Items",
            fields = {
                {name = "You have items", value=JSON.stringify(items)}
            },
            color = DISCORDIA.Color.fromRGB(170,26,232).value,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
    }
end)

command.Register('debug-add-apples', 'See your items', 'economy', function(msg, args)
	local id = DB.CreateRowUser(msg.author.id)
	local items = DB.GetUserItems(id)
	
	items.Apple = {
		quantity = 5
	}
	
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
		msg:reply('You have ' .. items.Apple.quantity .. ' apples')
	else
		msg:reply('You have no apples,')
	end
end)