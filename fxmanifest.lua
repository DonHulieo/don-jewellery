fx_version 'cerulean'
game 'gta5'

author 'DonHulieo'
description 'Jewellery Store Heist for QBCore'
version '1.3.2'

shared_scripts {
  -- '@ox_lib/init.lua',
  '@qb-core/shared/locale.lua', 
  'locale/en.lua', 
  'locale/*.lua', 
  'config.lua'
}

client_script {
  '@PolyZone/client.lua', 
  '@PolyZone/BoxZone.lua', 
  'client/main.lua'}

server_scripts {
  '@oxmysql/lib/MySQL.lua', 
  'server/main.lua'
}

dependencies {
  'qb-core',
  'qb-target',
  'oxmysql', 
  'PolyZone'
}

lua54 'yes'
