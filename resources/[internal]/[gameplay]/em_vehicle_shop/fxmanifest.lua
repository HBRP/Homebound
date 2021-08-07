
fx_version 'bodacious'
games { 'gta5' }

client_scripts {
	'@menuv/menuv.lua',
	'config.lua',
	'client/c_vehicle_shop_utils.lua',
	'client/c_vehicle_shop.lua',
	'client/c_vehicle_stock_purchase.lua',
	'@em_fun/c_fun.lua'
}

dependencies {
	'em_dal',
	'em_context',
	'em_vehicles',
	'em_form',
	't-notify',
	'em_fun'
}