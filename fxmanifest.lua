fx_version 'cerulean'
game 'gta5'

author 'tibbycode'
description 'Pause menu using ox_lib for FiveM'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client.lua', 
}

server_scripts {
    'server.lua', 
}

dependencies {
    'ox_lib'
}