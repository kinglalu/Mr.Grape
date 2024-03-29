-- https://github.com/stein197/lua-string
local discordia = require("discordia")
discordia.extensions()
_G.fs = require("fs")
_G.path = require("path")
_G.CORO = require("coro-http")
_G.SPAWN = require("coro-spawn")
_G.TIMER = require("timer")
_G.JSON = require("json")
_G.DISCORDIA = discordia
_G.CLIENT = discordia.Client()
_G.CONFIG = require("./config.lua")
require("./lib/string.lua")
_G.EMBEDCOLOR = DISCORDIA.Color.fromRGB(170, 26, 232).value
_G.NODECLUSTERS = "Powered by [NodeClusters](https://nodeclusters.com/billing/aff.php?aff=7)."


function _G.encodeURI(str)
	return (str:gsub("([^A-Za-z0-9%_%.%-%~])", function(v)
			return string.upper(string.format("%%%02x", string.byte(v)))
	end))
end


-- Polyfill
function math.round(x)
	local decimal = x - math.floor(x)

	if decimal < 0.5 then -- floor
		return x - decimal
	else -- ceil
		return x + (1 - decimal)
	end
end

local function setGame()
	local numbersOfGuilds = #_G.CLIENT.guilds

	if numbersOfGuilds == 1
	then
		game = " for +help in a server"
	else
		game =  "for +help in " .. numbersOfGuilds .. " servers"
	end
	_G.CLIENT:setGame{ name = game, type = 3 }
end

_G.CLIENT:on("ready", function()
	print("Ready!")
	setGame()
end)
CLIENT:on("guildCreate",function()
	setGame()
end)
CLIENT:on("guildDelete",function()
	setGame()
end)

print("[LIBRARIES]", "Loading library files")
for k, v in fs.scandirSync("./lib") do
	print("[LIBRARIES]", "Loading:", k)
	local data = require("./lib/"..k)
	print("	", "[LIBRARIES]", "Success:", k, "has been loaded.")
end

print("[HANDLERS]", "Loading handler files")
for k, v in fs.scandirSync("./handler") do
	print("[HANDLERS]", "Loading:", k)
	local data = require("./handler/"..k)
	if not data.name then
		print("	", "[HANDLERS]", "Error:", k, "does not have a valid name!")
	elseif _G[data.name] then
		print("	", "[HANDLERS]", "Error:", k, "has a name which is already registered as a handler. The name is", data.name)
	else
		_G[data.name] = data
		print("	", "[HANDLERS]", "Success:", k, "has been loaded with the name", data.name)
	end
end

print("[CMDS]", "Loading command files")
for k, v in fs.scandirSync("./commands") do
	print("[CMDS]", "Loading:", k)
	local data = require("./commands/"..k)
	print("	", "[CMDS]", "Success:", k, "has been loaded.")
end

--[[print("[EVENTS]", "Loading command files")
for k, v in fs.scandirSync("./events") do
	print("[EVENTS]", "Loading:", k)
	local data = require("./events/"..k)
	print("	", "[EVENTS]", "Success:", k, "has been loaded.")
end]]--

CLIENT:run('Bot ' .. CONFIG.token)