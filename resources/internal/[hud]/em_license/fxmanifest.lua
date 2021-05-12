
fx_version 'bodacious'
games { 'gta5' }

client_scripts {
    'client/c_license.lua'
}

ui_page "ui/index.html"

files {
    "ui/index.html",
    'ui/css/*.css',
    'ui/img/*.png',
    'ui/libs/jquery-ui.min.js',
    'ui/js/license.js'
}

dependencies {

    'em_fw',
    'em_items'

}