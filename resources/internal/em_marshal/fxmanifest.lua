fx_version 'bodacious'

game 'gta5'

server_scripts {
    'server/clock_in_station_server.lua'
}

client_scripts {

    'client/clock_in_station.lua',
    'client/locker_station.lua',
    'client/arp_marshal_client.lua'

}

export 'IsMarshal'