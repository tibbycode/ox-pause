RegisterNetEvent('qb-core:server:disconnectPlayer', function()
    local src = source
    DropPlayer(src, "You have been disconnected from the server.")
end)