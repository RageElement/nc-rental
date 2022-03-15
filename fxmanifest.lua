fx_version 'cerulean'
games { 'gta5' }

--Original qbcore script by 'NaorNC - github.com/NaorNC', then edited by Vumon for esx legacy 'Vumon - github.com/vumono'
--Edited version for mf-inventory by faizy - github.com/RageElement
author 'NaorNC, Vumon, & faizy'
description 'Vehicle Rental'
version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
  'client/cl_*.lua',
}

shared_scripts {
  '@es_extended/imports.lua',
  'config.lua'
}
server_scripts {
	'@es_extended/locale.lua',
  'server/sv_*.lua',
}

dependancies {
  'mf-inventory'
}
