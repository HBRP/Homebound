
fx_version 'bodacious'
games { 'gta5' }

client_scripts {
    'client/c_bank.lua',
    'client/c_atms.lua'
}

server_scripts {
    'server/s_atms.lua'
}

ui_page {
    'html/ui.html',
}

files {
    'html/ui.html',
    'html/scripts/bank.js',
    'html/css/bank.css',
    'html/css/bulma/css/bulma.min.css',
    'html/images/*.png'
}

dependencies {
    
    'em_dal',
    'em_commands',
    'em_dialog',
    'em_transactions',
    't-notify'

}