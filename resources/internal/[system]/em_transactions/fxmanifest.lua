
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_transactions.lua'
}

exports {

    'get_cash_on_hand',
    'remove_cash'

}

dependencies {

    'em_dal',
    'em_items',
    't-notify'

}