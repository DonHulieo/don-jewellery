fx_version 'cerulean'
game 'gta5'

author 'DonHulieo'
description 'Jewelery Store Heist for QBCore'
version '1.2.0'

shared_scripts {'@qb-core/shared/locale.lua', 'locale/en.lua', 'locale/*.lua', 'config.lua'}

client_script {'@PolyZone/client.lua', '@PolyZone/BoxZone.lua', 'client/main.lua'}

server_scripts {"@oxmysql/lib/MySQL.lua", 'server/main.lua'}

dependencies {'qb-core', 'qb-target', 'qb-scoreboard', 'oxmysql', 'PolyZone'}

lua54 'yes'
