command.Register("ask", "Ask a question that Mr grape may be able to answer! Uses wolfram alpha.","fun",function(msg, args)
	local response = msg:reply("Give me a second...")
	local answer = nil
	
	local usedURL = "https://api.wolframalpha.com/v2/query?appid="..CONFIG.wolfram.."&input="..encodeURI(msg.content:gsub(PREFIX .. "ask ", "")).."&format=plaintext&output=JSON"
		
	coroutine.wrap(function()
		pcall(function()
			local res, data = CORO.request("GET", usedURL)
			local result = JSON.parse(data)
			answer = result["queryresult"]["pods"][2]["subpods"][1].plaintext
		end)
		
		if answer == nil then
			response:setContent("I didn't understand that question!")
			return nil
		end
		
		response:update({
			embed = {
				title = "Answer",
				description = "Question:\n"..msg.content:gsub(PREFIX .. "ask ", ""),
				fields = {
					{name = "Answer:", value = answer }
				},
				color = EMBEDCOLOR,
				timestamp = DISCORDIA.Date():toISO('T', 'Z')
			}
		})
	end)()
end)