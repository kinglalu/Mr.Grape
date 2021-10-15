command.Register("help", "Display's info about all the commands.","utility",function(msg, args)
    function print_table(node)
        local cache, stack, output = {},{},{}
        local depth = 1
        local output_str = "{\n"
    
        while true do
            local size = 0
            for k,v in pairs(node) do
                size = size + 1
            end
    
            local cur_index = 1
            for k,v in pairs(node) do
                if (cache[node] == nil) or (cur_index >= cache[node]) then
    
                    if (string.find(output_str,"}",output_str:len())) then
                        output_str = output_str .. ",\n"
                    elseif not (string.find(output_str,"\n",output_str:len())) then
                        output_str = output_str .. "\n"
                    end
    
                   
                    table.insert(output,output_str)
                    output_str = ""
    
                    local key
                    if (type(k) == "number" or type(k) == "boolean") then
                        key = "["..tostring(k).."]"
                    else
                        key = "['"..tostring(k).."']"
                    end
    
                    if (type(v) == "number" or type(v) == "boolean") then
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                    elseif (type(v) == "table") then
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                        table.insert(stack,node)
                        table.insert(stack,v)
                        cache[node] = cur_index+1
                        break
                    else
                        output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                    end
    
                    if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                    else
                        output_str = output_str .. ","
                    end
                else
                    if (cur_index == size) then
                        output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                    end
                end
    
                cur_index = cur_index + 1
            end
    
            if (size == 0) then
                output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
            end
    
            if (#stack > 0) then
                node = stack[#stack]
                stack[#stack] = nil
                depth = cache[node] == nil and depth + 1 or depth - 1
            else
                break
            end
        end
    
        
        table.insert(output,output_str)
        output_str = table.concat(output)
    
        return output_str
    end
    
	local embed = {
        title = "Mr Grape's Commands",
        fields = {},
        color = DISCORDIA.Color.fromRGB(170,26,232).value,
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
				color = DISCORDIA.Color.fromRGB(170,26,232).value,
				timestamp = DISCORDIA.Date():toISO('T', 'Z')
			}
        })
        return nil
	elseif #args == 1 then
		for index,value in pairs(command.commands) do
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