
var cache_accounts     = null
var cache_pending      = null
var cache_transactions = null

function load_account(bank_account_id) {

    $('.summary_box').hide();
    $('.account_summary_box').show();
    $('.account_actions_box').show();
    for (var i = 0; i < cache_accounts.length; i++) {

        if (cache_accounts[i].bank_account_id == bank_account_id) {

            $('.account_summary_title').text('Viewing account: ' + cache_accounts[i].bank_account_name)
            $('.account_funds_text').html('<b>Available Funds:</b> $' + cache_accounts[i].funds)
            break;

        }

    }

    $('.deposit_button').click(function() {

        $('.deposit_money_modal').addClass('is-active')

    })

    $('.withdraw_button').click(function() {

        $('.withdraw_money_modal').addClass('is-active')

    })

    $('.transfer_button').click(function() {



    })

    $('.delete_button').click(function() {



    })

}

function populate_accounts(accounts) {

    cache_accounts = accounts;

    var element = '<a class="navbar-item account-item" bank_account_id="{id}">({id}) {name}</a>'
    for (var i = 0; i < accounts.length;i++) {

        var new_element = element.replace("{name}", accounts[i].bank_account_name).replaceAll("{id}", accounts[i].bank_account_id)
        $(".accounts-dropdown").append(new_element)

    }

    var networth = 0;
    for (var i = 0; i < accounts.length;i++) {

        if (accounts[i].owner) {

            networth += accounts[i].funds;

        }

    }
    $(".networth").empty();
    $(".networth").append('<b>Networth: </b>${}'.replace("{}", networth))

    $(".account-item").click(function() {

        var bank_account_id = $(this).attr("bank_account_id")
        load_account(bank_account_id)

    });
    
}

function populate_pending(pending) {

    var element = '<tr><td>{0}</td><td>{1}</td><td>${2}</td><td>{3}</td></tr>'
    for (var i = 0; i < pending.length;i++) {

        var new_element = element.replace("{0}", pending[i].bank_account_name).replace("{1}", pending[i].pending_trasaction_date).replace("{2}", pending[i].amount).replace("{3}", !pending[i].current)
        $(".pending_transactions_data").append(new_element)

    }

    var amount_due = 0;
    for (var i = 0;i < pending.length;i++) {

        amount_due += pending[i].amount;

    }
    $(".total-due").empty();
    $(".total-due").append('<b>Amount Due: </b>${}'.replace("{}", amount_due));

}

const bank_transaction_types = {1 : "ACH", 2 : "Withdrawal", 3 : "Deposit", 4 : "Wire Transfer"}

function populate_transactions(transactions) {

    var element = '<tr><td>{0}</td><td>{1}</td><td>${2}</td><td>{3}</td></tr>'
    for (var i = 0; i < transactions.length; i++) {

        var transaction_type = bank_transaction_types[transactions[i].transaction_type_id]
        var new_element = element.replace("{0}", transactions[i].bank_account_name).replace("{1}", transactions[i].transaction_date).replace("{2}", transactions[i].amount).replace("{3}", transaction_type)
        $(".recent_transactions_data").append(new_element)

    }

}

function display() {

    $(".container-background").fadeIn();

}

function empty_out_data() {

    $(".accounts-dropdown").empty();
    $(".pending_transactions_data").empty();
    $(".recent_transactions_data").empty();

}

function hide() {

    empty_out_data();
    $(".container-background").fadeOut();

}

function test_populate() {

    populate_accounts([
        {
            "bank_account_id":1,
            "bank_account_name":"test",
            "funds": 10010,
            "owner": true
        },
        {
            "bank_account_id":2,
            "bank_account_name":"test2",
            "funds": 10111,
            "owner": false
        }
    ]);
    populate_pending([

        {
            "bank_account_name": "bank_account_name",
            "bank_pending_transaction_id":1,
            "pending_trasaction_date": "",
            "reason": "Because",
            "amount": 100,
            "amount_left": 120,
            "current": true
        },
        {
            "bank_account_name": "bank_account_name",
            "bank_pending_transaction_id":2,
            "pending_trasaction_date": "",
            "reason": "Because Yes",
            "amount": 100,
            "amount_left": 100,
            "current": false
        }

    ]);

    populate_transactions([
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 100,
            "transaction_date": "",
            "transaction_type_id": 1
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 200,
            "transaction_date": "",
            "transaction_type_id": 2
        }
    ]);

}

$(function() {

    test_populate();

    $('.home-navbar-item').click(function() {

        empty_out_data();
        $('.summary_box').show();
        $('.account_summary_box').hide();
        $('.account_actions_box').hide();
        test_populate();
        $.post("http://em_bank/refresh_bank", JSON.stringify({}))

    })

    window.addEventListener("message", function (event) {

        if (event.data.display) {

            display();

        } else if (event.data.populate_accounts) {

            populate_accounts(event.data.accounts);


        } else if (event.data.populate_pending) {

            populate_pending(event.data.pending);

        } else if (!event.data.display) {


        }

    })

})