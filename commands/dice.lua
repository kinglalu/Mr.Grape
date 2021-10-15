command.Register("dice", "Roll a dice!","fun",function(msg, args)
    local flip = math.random(1,6)
    msg:reply{
        embed = {
            title = "🎲 Dice Roll",
            description = "Your roll landed on...   ".."**"..flip.."**".." !",
            color = DISCORDIA.Color.fromRGB(170,26,232).value,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
    }
end)