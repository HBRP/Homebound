
fx_version 'bodacious'
games { 'gta5' }

client_scripts {
	'@menuv/menuv.lua',
	'config.lua',
	'client/em_vehicle_shop.lua',
	'cllient/em_vehicle_stock_purchase.lua'
}

dependencies {
	'em_dal',
	'em_context',
	'em_vehicles'
}