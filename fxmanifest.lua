fx_version 'cerulean'
game 'gta5'

lua54 'yes'

title 'Os Multijobs'
description 'Multijob application for LB-Phone (QBX/QB/ESX)'
author 'Oscar Dev.'
version '3.0.2'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'locales/*.lua',
    'locales/loader.lua',
    'bridge/sh_bridge.lua',
}

client_scripts {
    'bridge/core/cl_*.lua',
    'bridge/player/cl_*.lua',
    'client/config.lua',
    'client/app.lua',
    'phone/*.lua',
    'client/standalone.lua',
    'client/jobs.lua',
    'compatibility/*/client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/core/sv_*.lua',
    'bridge/player/sv_*.lua',
    'server/config.lua',
    'server/utils.lua',
    'server/callbacks.lua',
    'server/events.lua',
    'compatibility/*/server/*.lua',
}

files {
    'ui/**/*'
}

ui_page 'ui/standalone/index.html'

provide "ps-multijob"

dependency 'ox_lib'