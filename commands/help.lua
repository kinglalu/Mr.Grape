command.Register("help", "Display's info about all the commands.","utility",function(msg, args)
    local embed = {
        title = "Mr Grape's Commands",
        fields = {},
        color = EMBEDCOLOR,
        timestamp = DISCORDIA.Date():toISO('T', 'Z')
    }
	
	if #args == 0 then
		assert(msg:reply{
			embed = {
				title = "Mr Grape's Commands",
				fields = {
                    {name = "Categories", value = "Economy\nUtility\nFun\nModeration\nMusic", inline = true},
                    {name = "Use +help <category> to see each category's commands", value = "ㅤ", inline = false},
				},
				color = EMBEDCOLOR,
				timestamp = DISCORDIA.Date():toISO('T', 'Z')
			}
        })
        return nil
	elseif #args == 1 then
		for index, value in pairs(command.commands) do
			if value["category"] == args[1]:lower() then
				table.insert(embed["fields"], {
					name = index,
					value = value["desc"]
                })
			end
        end
	end
    
--[[
local embed = {
    title = "Mr Grape's Commands",
    fields = {},
    color = DISCORDIA.Color.fromRGB(170,26,232).value,
    timestamp = DISCORDIA.Date():toISO('T', 'Z')
}

for index,value in pairs(command.commands) do
    table.insert(embed["fields"], {
        name = index,
        value = value["desc"]
    })
end ]]--

if #embed["fields"] == 0 and #args == 1 then
    msg:reply("Not a valid category!")
else
    -- set description to the category name
    if #args >= 2 then
        local s = args[1]:lower()
        -- first character uppercase
        embed["description"] = s:sub(1,1):upper()..s:sub(2)
    end
    
    msg:reply{
        embed = embed
    }
end
end)