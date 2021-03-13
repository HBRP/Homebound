fx_version 'bodacious'
games { 'gta5' }

client_script 'client/c_command_register.lua'
client_script 'client/c_basic_commands.lua'

server_script 'server/s_basic_commands.lua'

export 'register_command'

dependencies {

    'em_fw'

}
