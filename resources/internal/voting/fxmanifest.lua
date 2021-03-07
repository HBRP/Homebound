fx_version 'bodacious'

game 'gta5'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'voting_server.lua'
}

client_scripts {

    'voting_client.lua'

}