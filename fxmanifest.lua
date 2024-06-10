fx_version 'cerulean'
games {'gta5'}
lua54 "yes"

author "Niknock HD"
description "NKHD Insurance QB Core Version"
version "1.0.0"

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'qb-core',
    'ox_lib'
}
