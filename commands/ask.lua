command.Register("ask", "Ask a question that Mr grape may be able to answer! Uses wolfram alpha.","fun",function(msg, args)
  local response = msg:reply("Give me a second...")
  function askquestion()
    local questionbasic = msg.content:gsub(PREFIX .. "ask ", "")
    local question = FUNCTIONS.urlencode(questionbasic)
    local usedURL = "https://api.wolframalpha.com/v2/query?appid="..CONFIG.wolfram.."&input="..question.."&format=plaintext&output=JSON"
    local res, data = CORO.request("GET", usedURL)
    local result = JSON.parse(data)
    
    local answer = result["queryresult"]["pods"][2]["subpods"][1].plaintext
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
    end
  
    if pcall(askquestion) then
      -- respond with answer
  else
      response:setContent("I didn't understand that question!")
  end
end)