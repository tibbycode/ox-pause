---@diagnostic disable: unused-local
local webhookURL = 'https://discord.com/api/webhooks/1287590750019653722/qO19JfEB2s9ppbPNMcdRKuIzAldgSOI4vocnBCNwRF-IixL0wNHmhHNQoeMd2AcEZJvB'

RegisterNetEvent('qb-core:server:sendReport', function(reason, discord)
    local src = source
    local playerName = GetPlayerName(src)
    local reportMessage = {
        {
            ["color"] = 16711680,
            ["title"] = "New Report",
            ["description"] = string.format("**Player:** %s\n**Reason:** %s\n**Discord:** %s", playerName, reason, discord),
            ["footer"] = {
                ["text"] = os.date('%Y-%m-%d %H:%M:%S', os.time())
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Report Bot", embeds = reportMessage}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent('qb-core:server:disconnectPlayer', function()
    local src = source
    DropPlayer(src, "You have been disconnected from the server.")
end)