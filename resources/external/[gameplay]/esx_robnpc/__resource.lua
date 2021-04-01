resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Rob NPC'

server_scripts {
     'config.lua',
     'server/main.lua'
}

client_scripts {
    'config.lua',
    'client/main.lua'
}

dependencies {
    'em_fw',
    't-notify',
    'em_commands',
    'rprogress'
}