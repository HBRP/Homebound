
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

	'client/c_form.lua'

}

ui_page 'html/ui.html'

files {
    "html/ui.html",
    'html/css/*.css',
    'html/css/bulma/css/bulma.min.css',
    'html/scripts/form.js'
}

exports {

	'display_form',
	'get_form_value'

}