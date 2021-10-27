command.Register("ask", "Ask a question that Mr grape may be able to answer! Uses wolfram alpha.","fun",function(msg, args)
    local question = msg.content:gsub(PREFIX .. "ask ", ""):gsub("%s+", "+")
    local res, data = CORO.request("GET", "https://api.wolframalpha.com/v2/query?appid="..CONFIG.wolfram.."&input="..question.."&format=plaintext&output=JSON")
    local result = JSON.parse(data)
  -- print(FUNCTIONS.print_table(result))
   local answer = result["queryresult"]["pods"][2]["subpods"][1].plaintext 
  -- print(FUNCTIONS.print_table(result["queryresult"]["pods"]))
    msg:reply({
        embed = {
          title = "Answer",
          description = "Question:\n"..msg.content:gsub(PREFIX .. "ask ", ""),
          fields = {
            {name = "Answer:", value = answer }
          },
          color = DISCORDIA.Color.fromRGB(170, 26, 232).value,
          timestamp = DISCORDIA.Date():toISO('T', 'Z')
        }
      })
end)