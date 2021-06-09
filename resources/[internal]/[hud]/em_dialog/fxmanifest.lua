
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_dialog.lua'

}

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/css/dialog.css",
    "ui/scripts/dialog.js",
    'ui/images/Splash-PNG-Download-Image.png'
}

exports {

    'show_dialog',
    'hide_dialog'

}