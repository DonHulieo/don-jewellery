fx_version 'cerulean'
game 'gta5'

description 'Don\'s QB-Jewelry'
version '1.1.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locale/en.lua',
    'locale/*.lua',
    'config.lua'
}

client_script {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/main.lua'
}
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    'server/main.lua'
}

lua54 'yes'
