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
            title = 'Report',
            description = 'Report an issue or player',
            icon = 'exclamation-triangle',
            iconColor = 'orange',
            onSelect = function()
                -- Open report input dialog
                local input = lib.inputDialog('Report Issue/Player', {
                    {type = 'input', label = 'Reason for Report', description = 'Describe the issue or player behavior', required = true},
                    {type = 'input', label = 'Your Discord', description = 'Enter your Discord ID for contact', required = true}
                })

                if input then
                    -- Send report to server
                    TriggerServerEvent('qb-core:server:sendReport', input[1], input[2])
                end
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
        -- Remove blur effect when the menu is closed
        ClearTimecycleModifier()
    end
})

RegisterCommand('togglePauseMenu', function()
    local openMenu = lib.getOpenContextMenu()
    if openMenu == 'pause_menu' then
        lib.hideContext(true)
        -- Remove blur effect when the menu is closed
        ClearTimecycleModifier()
    else
        lib.showContext('pause_menu')
        -- Play frontend sound when the menu is opened
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        -- Apply blur effect when the menu is opened
        SetTimecycleModifier("hud_def_blur")
        SetTimecycleModifierStrength(1.0)
    end
end)

RegisterKeyMapping('togglePauseMenu', 'Toggle Pause Menu', 'keyboard', 'ESCAPE')