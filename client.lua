---@diagnostic disable: unused-local

local config = {
    enableCamera = false, -- Set this to false to disable the camera feature
}

local camera = nil

-- Function to handle camera creation and setup
local function setupCamera()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local camCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.8) -- Adjusted for close-up view in front of the player
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(camera, camCoords.x, camCoords.y, camCoords.z)
    PointCamAtCoord(camera, playerCoords.x, playerCoords.y, playerCoords.z + 0.6) -- Adjusted to point at the face without moving the player
    SetCamActive(camera, true)
    RenderScriptCams(true, false, 0, true, true)
end

-- Function to handle camera destruction
local function destroyCamera()
    if config.enableCamera and camera then
        DestroyCam(camera, false)
        RenderScriptCams(false, false, 0, true, true)
        camera = nil
    end
end

-- Function to handle player animation
local function playAnimation()
    local playerPed = PlayerPedId()
    RequestAnimDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
    while not HasAnimDictLoaded("amb@world_human_hang_out_street@female_hold_arm@idle_a") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(playerPed, "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false)
end

-- Function to handle player freezing
local function freezePlayer(freeze)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, freeze)
    if freeze then
        TaskStandStill(playerPed, -1)
    else
        ClearPedTasksImmediately(playerPed)
    end
end

-- Disable control action in a separate thread
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
                Citizen.CreateThread(function()
                    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
                    Wait(100)
                    PauseMenuceptionGoDeeper(0)
                    while true do
                        Citizen.Wait(10)
                        if IsControlJustPressed(0, 200) then
                            SetFrontendActive(0)
                            break
                        end
                    end
                end)
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

                -- Clear the timecycle modifier after the input dialog is closed
                ClearTimecycleModifier()
                -- Destroy the camera if it exists
                destroyCamera()
                -- Unfreeze the player and clear animation
                freezePlayer(false)
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
        -- Destroy the camera if it exists
        destroyCamera()
        -- Unfreeze the player and clear animation
        freezePlayer(false)
    end
})

RegisterCommand('togglePauseMenu', function()
    local openMenu = lib.getOpenContextMenu()
    if openMenu == 'pause_menu' then
        lib.hideContext(true)
        -- Remove blur effect when the menu is closed
        ClearTimecycleModifier()
        -- Destroy the camera if it exists
        destroyCamera()
        -- Unfreeze the player and clear animation
        freezePlayer(false)
    else
        lib.showContext('pause_menu')
        -- Play frontend sound when the menu is opened
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        -- Apply blur effect when the menu is opened
        SetTimecycleModifier("bloom")
        SetTimecycleModifierStrength(1.0)
        -- Create and set up the camera if enabled
        if config.enableCamera then
            setupCamera()
            -- Freeze the player and play animation
            freezePlayer(true)
            playAnimation()
        end
    end
end)

RegisterKeyMapping('togglePauseMenu', 'Toggle Pause Menu', 'keyboard', 'ESCAPE')