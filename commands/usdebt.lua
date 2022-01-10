local util = require('../lib/util.lua')

command.Register("usdebt", "Shows America's national debt to the penny.","fun",function(msg, args)
    local res, data = CORO.request("GET", "https://api.fiscaldata.treasury.gov/services/api/fiscal_service/v2/accounting/od/debt_to_penny?sort=-record_date")
    local debt = JSON.parse(data)
    msg:reply({
        embed = {
          title = "America's debt to the penny!",
          fields = {
            {name = "**As of "..debt["data"][1].record_date.."**", value = "The US total public debt is \n **$"..util.format_int(debt["data"][1].tot_pub_debt_out_amt).."**"},
            {name = "ㅤ", value = "[Fiscal Data, Treasury.gov](https://fiscaldata.treasury.gov)"}
        },

          color = EMBEDCOLOR,
          timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
      })
end)