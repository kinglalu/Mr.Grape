command.Register("dice", "Roll a dice!","fun",function(msg, args)
    local flip = math.random(1,6)
    msg:reply{
        embed = {
            title = "🎲 Dice Roll",
            description = "Your roll landed on...   ".."**"..flip.."**".." !",
            color = EMBEDCOLOR,
            timestamp = DISCORDIA.Date():toISO('T', 'Z')
          }
    }
end)