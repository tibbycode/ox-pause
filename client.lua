---@diagnostic disable: unused-local

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DisableControlAction(0, 200, true)
    end
end)

lib.registerContext({
    id = 'pause_menu',
    title = 'Pause Menu',
    options = {
        {
            title = 'Settings',
            description = 'Open settings menu',
            icon = 'cogs',
            iconColor = 'dodgerblue',
            onSelect = function()
                SetNuiFocus(false, false)
                ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_LANDING_MENU"), false, -1)
            end
        },
        {
            title = 'Map',
            description = 'Open the map',
            icon = 'map-marked-alt',
            iconColor = 'limegreen',
            onSelect = function()
                SetNuiFocus(false, false)
                ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
                Wait(60)
                SetFrontendActive(true)
            end
        },
        {
            title = 'Quit Game',
            description = 'Quit the game',
            icon = 'power-off',
            iconColor = 'red',
            onSelect = function()
                SetNuiFocus(false, false)
                TriggerServerEvent('qb-core:server:disconnectPlayer')
            end
        }
    },
    onExit = function()
    end
})

RegisterCommand('togglePauseMenu', function()
    local openMenu = lib.getOpenContextMenu()
    if openMenu == 'pause_menu' then
        lib.hideContext(true)
    else
        lib.showContext('pause_menu')
    end
end)

RegisterKeyMapping('togglePauseMenu', 'Toggle Pause Menu', 'keyboard', 'ESCAPE')