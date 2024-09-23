![image](https://github.com/user-attachments/assets/1b59d3a2-e4fb-4025-b1f5-820030bd56ff)

# Pause Menu Script

This script provides a customizable pause menu for your FiveM server, allowing players to access various options such as viewing the map, opening settings, reporting issues, and quitting the game. The script also includes optional camera and animation features.

## Features

- Customizable pause menu with multiple options
- Optional camera feature for a close-up view of the player
- Player animation while the menu is open
- Player freezing to prevent movement during menu interaction

## Installation

1. **Download and Extract**: Download the script and extract it to your `resources` folder.

2. **Add to Server Configuration**: Add the following line to your `server.cfg` to ensure the script is loaded:

    ```cfg
    ensure ox-pause
    ```

3. **Set Environment Variable**: Add the webhook URL to your server configuration file (`server.cfg`):

    ```cfg
    set report_webhook_url "https://discord.com/api/webhooks/YOUR_WEBHOOK_URL"
    ```

## Configuration

The script includes a configuration option to enable or disable the camera feature. You can modify this in the `client.lua` file:

```lua
local config = {
    enableCamera = false, -- Set this to true to enable the camera feature
}

Menu Options
Map: Opens the in-game map.
Settings: Opens the settings menu.
Report: Opens a dialog to report an issue or player. The report is sent to a specified Discord webhook.
Quit Game: Disconnects the player from the server.
