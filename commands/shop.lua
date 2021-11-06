command.Register("shop", "Displays the shop for items you can buy with :star:", "economy", function(msg, args)
    local DB = require('../handler/items.lua')
    local items = DB.KnownItems
    local embed = {
        title = "Shop",
        description = "`Buy an item by using "..PREFIX.."buy <itemname>!`",
		fields = {},
		color = DISCORDIA.Color.fromRGB(170,26,232).value,
        timestamp = DISCORDIA.Date():toISO('T', 'Z')
    }
    
    for i,v in pairs(items) do
		table.insert(embed.fields, {name=i,value=v.description..'\n'..v.price..':star:'})
    end
    assert(msg:reply{embed = embed})
end)