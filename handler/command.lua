local COMMAND = {}

COMMAND.name = "command"
COMMAND.commands = {}
COMMAND.prefix = "+"
_G.PREFIX = COMMAND.prefix

function COMMAND.SetPrefix(command)
	COMMAND.prefix = command or "+"
end

function COMMAND.GetPrefix()
	return command.prefix
end

function COMMAND.Register(command, desc, category, func)
	if not command then
		print("[COMMAND]", "[Error]", "Invalid command name given")
		return
	end

	if not func then
		print("[COMMAND]", "[Error]", "Invalid  function given")
		return
	end

	command = string.lower(command)

	COMMAND.commands[command] = {
		command = command,
		desc = desc or "n/a",
		category = category or "n/a",
		func = func
	}

	print("[COMMAND]", "The command", command, "has now been registered")
end

function COMMAND.Reload(command)
	package.loaded[command] = nil
end

function COMMAND.GetCommand(command)
	return COMMAND.commands[command] or false
end

function COMMAND.FormatArguments(args)
	local Start, End = nil, nil

	for k, v in pairs(args) do
		if (string.sub(v, 1, 1) == "\"") then
			Start = k
		elseif Start and (string.sub(v, string.len(v), string.len(v)) == "\"") then
			End = k
			break
		end
	end

	if Start and End then
		args[Start] = string.Trim(table.concat(args, " ", Start, End), "\"")

		for i = 1, (End - Start) do
			table.remove(args, Start + 1)
		end

		args = command.FormatArguments(args)
	end

	return args
end

if CONFIG.commandEvent then
	CLIENT:on("messageCreate", function(msg)
		local author = msg.author
		local content = msg.content
		if author == CLIENT.user then return end
		if author.bot then return end

		local prefix = command.GetPrefix()

		if not (string.sub(content, 1, string.len(prefix)) == prefix) then
			return
		end
		
		local args = command.FormatArguments(string.Explode(" ", content))

		args[1] = string.sub(args[1], string.len(prefix) + 1)

		local command = command.GetCommand(string.lower(args[1]))

		if not command then print("Invalid command", "'"..args[1].."'") return end

		table.remove(args, 1)

		command.func(msg, args)
	end)
end

COMMAND.cooling = {}

-- Boolean; Returns true if the command is on cooldown for the message sender, false if they arent
function COMMAND.Cooldown(message, id, time, response)
	local id = tostring(message.author.id)
	
	if COMMAND.cooling[id] == nil then COMMAND.cooling[id] = {} end

	local cmds = COMMAND.cooling[id]
	local cooldown = false;

	if cmds[id] ~= nil then
		local expires = cmds[id]
		
		local now = os.time()
		
		if expires < now then
			cmds[id] = nil
		else 
			cooldown = expires - now
		end
	else
		cmds[id] = os.time() + time
	end

	if cooldown == false then return false end

	if response == nil then response = "You need to wait  %s seconds to run this command again." end

	message:reply(response:gsub('%%s', cooldown))
	
	return true
end

-- Guild Member; Returns the first mention, first ID, or author of the message specified 
function COMMAND.FirstMention(message)
	local args = string.Explode(" ", message.content)
	local mention = message.mentionedUsers.first;
	
	if mention ~= nil then mention = message.guild:getMember(mention) end
	if mention == nil and #args > 1 then mention = message.guild:getMember(args[2]) end
	if mention == nil then mention = message.guild:getMember(message.author) end

	return mention
end

return COMMAND