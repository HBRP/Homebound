fx_version 'bodacious'
games { 'gta5' }

ui_page 'html/index.html'

files {

	'html/index.html',
	'html/static/css/*',
	'img/items/*',
	'html/static/js/*',
	'html/*.json'

}

client_scripts {

	'client/c_em_crafting.lua'

}

dependencies {

	'em_dal',
	'em_items',
	'em_commands',
	't-notify'

}