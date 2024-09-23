---@diagnostic disable: unused-local

-- Load the webhook URL from an environment variable for security
local webhookURL = GetConvar('report_webhook_url', '')

if webhookURL == '' then
    print("Error: Webhook URL is not set. Please set the 'report_webhook_url' in server cfg.")
    return
end

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

    PerformHttpRequest(webhookURL, function(err, text, headers)
        if err ~= 200 then
            print(string.format("Failed to send report: %s", err))
        else
            print("Report sent successfully.")
        end
    end, 'POST', json.encode({username = "Report Bot", embeds = reportMessage}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent('qb-core:server:disconnectPlayer', function()
    local src = source
    DropPlayer(src, "You have been disconnected from the server.")
end)