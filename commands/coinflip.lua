command.Register("coinflip", "Flip a coin for all those tough decisions!","fun", function(msg, args)
    local flip = math.random(1,2)
    local result = nil
    if flip == 1 then
        result = 'Heads'
    else
        print("tails")
        result = 'Tails'
    end
    msg:reply{
        embed = {
            title = ":coin: CoinFlip",
            description = "Your coin landed on...   ".."**"..result.."**".." !",
            color = DISCORDIA.Color.fromRGB(170,26,232).value,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
    }
end)