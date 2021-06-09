fx_version "cerulean"
game { "gta5" }

author 'Snake'
description 'A flexible player customization script for FiveM.'
repository 'https://github.com/snakewiz/fivem-appearance'
version '1.1.1'

client_script 'typescript/build/client.js'

files {
    'peds.json',
    'ui/build/index.html',
    'ui/build/static/js/*.js',
    'locales/*.json',
}

ui_page 'ui/build/index.html'