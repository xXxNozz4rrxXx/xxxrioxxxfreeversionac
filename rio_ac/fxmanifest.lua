fx_version 'adamant'

game 'gta5'

description 'RioAntiCheat 4.0.0 was created by xxx-Rio-xxx'
name 'RioAntiCheat 4.0.0'
author 'Gredits : PoodFood'
contact 'Rio'

version '3.2.0'

--server_only 'yes'

server_scripts {
    '@async/async.lua',
    '@mustache/mustache.lua',

    'RioAntiCheat.net.dll',

    'server/common.lua',
    'server/fake_events.lua',
    'server/globalbans.lua',
    'server/serversideA.lua',
    'server/rioreviveall.lua',

    'locales/en.lua',
    'locales/de.lua',
    'locales/fi.lua',
    'locales/tr.lua',
    'locales/ar.lua',
    'locales/es.lua',
    'locales/es2.lua',
    'locales/fr.lua',
    'locales/hu.lua',
    'locales/id.lua',
    'locales/pl.lua',
    'locales/pt.lua',
    'locales/ro.lua',


    'config.lua',

    'server/functions.lua',
    'server/main.lua',
}

client_scripts {
    'utils.lua',
    "aDetections.lua",
    'cconfig.lua',
}


server_exports {
	'getSharedObject',
}

dependencies {
    'async',
    'mustache',
}

--shared_script "/shared/shared.lua"
server_script "object_hashes.lua"