command.Register("shop", "Displays the shop for items you can buy with :star:", "economy", function(msg, args)
    local DB = require('../handler/items.lua')
    local items = DB.KnownItems
    local id = DB.CreateRowUser(msg.author)
    local personitems = DB.GetUserItems(id)
    local embed = {
        title = "Shop",
        description = "`Buy an item by using "..PREFIX.."buy <itemname>!`",
		fields = {},
		color = EMBEDCOLOR,
        timestamp = DISCORDIA.Date():toISO('T', 'Z')
    }
    
    for i,v in pairs(items) do
       for g,b in pairs(personitems) do
            if i == g then
                v.price = v.price*b.quantity
           end
        end 
		table.insert(embed.fields, {name=v.Emoji..i,value=v.description..'\n'..v.price..':star:'})
    end
    assert(msg:reply{embed = embed})
end)