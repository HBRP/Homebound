fx_version 'bodacious'

author 'Duart3x'
description 'ESX Vehicle Shop'
game 'gta5'

version '1.2.0'

client_scripts {
	'client/utils.lua',
	'client/main.lua'
}

ui_page "HTML/ui.html"

files {
    "HTML/ui.css",
    "HTML/ui.html",
	"HTML/ui.js",
	"HTML/imgs/*.jpg",
	"HTML/imgs/*.png",
}


exports {
	'OpenShopMenu'
}

dependencies {
	'em_vehicles',
	'em_transactions'
}