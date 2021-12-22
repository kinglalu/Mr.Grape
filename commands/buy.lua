command.Register("buy", "Purchase an item from the shop with :star:", "economy", function(msg, args)
    local DB = require('../handler/items.lua')
    local starDB = require('../handler/economy.lua')
    local shopitems = DB.KnownItems
    local id = DB.CreateRowUser(msg.author)
	local items = DB.GetUserItems(id)
    local stars = starDB.GetUserStars(id)
    local purchase = string.lower(tostring(args[1]))
    if purchase == nil then
        msg:reply("Please choose a valid item!")
    else
        local v = shopitems[purchase]
        if not v then
        msg:reply("Thats not a valid item!")
        return nil
end
    for g,b in pairs(items) do
        if v == g then
        v.price = v.price*b.quantity
   end
end 
                if stars >= v.price then -- has enough stars
                    if not items[purchase] then items[purchase] = { quantity = 0 } end
                    items[purchase].quantity = items[purchase].quantity + 1
                    stars = stars - v.price
                    starDB.SetUserStars(id, stars)
                    DB.SetUserItems(id, items)
                    msg:reply("Purchase Complete!")
                else
                    msg:reply("You don't have enough :star:")
        end
    end
end)