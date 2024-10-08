---@diagnostic disable: unused-local

-- Load the webhook URL from an environment variable for security
local webhookURL = GetConvar('report_webhook_url', '')

if webhookURL == '' then
    print("Error: Webhook URL is not set. Please set the 'report_webhook_url' in server cfg.")
    return
end

RegisterNetEvent('ox-pause:server:sendReport', function(reason, discord)
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
        if err == 200 or err == 204 then
            print("Report sent successfully.")
        else
            print(string.format("Failed to send report: %s, Response: %s", err, text))
        end
    end, 'POST', json.encode({username = "Report Bot", embeds = reportMessage}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent('ox-pause:server:disconnectPlayer', function()
    local src = source
    DropPlayer(src, "You have been disconnected from the server.")
end)