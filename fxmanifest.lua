fx_version 'cerulean'
games { 'gta5' }

--Original qbcore script by 'NaorNC - github.com/NaorNC'
--Edited version for ox_inventory and esx legacy by Vumon - github.com/vumono
version '1.0.0'

client_scripts {
  'config.lua',
  'client/cl_*.lua',
}

shared_scripts {
  '@es_extended/imports.lua'
}
server_scripts {
  'config.lua',
  'server/sv_*.lua',
}
