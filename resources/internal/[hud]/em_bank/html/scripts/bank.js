
var cache_accounts     = []
var cache_pending      = []
var cache_transactions = []

function load_account(bank_account_id) {

    $('.summary_box').hide();
    $('.account_summary_box').show();
    $('.account_actions_box').show();
    for (var i = 0; i < cache_accounts.length; i++) {

        if (cache_accounts[i].bank_account_id == bank_account_id) {

            $('.account_summary_title').text('Viewing account: ' + cache_accounts[i].bank_account_name)
            $('.account_funds_text').html('<b>Available Funds:</b> $' + cache_accounts[i].funds)
            $('.account_id').html('<b>Account Number: </b>' + bank_account_id)
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

        var bank_account_id = $(this).attr("bank_account_id");
        empty_out_data();
        test_populate();
        load_account(bank_account_id);

    });
    
}

function populate_pending(pending) {

    $(".pending_transaction_table_div").html(
        `
            <table id="pending_transaction_table" class="table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Account</th>
                        <th>Amount</th>
                        <th>Past Due</th>
                    </tr>
                </thead>
                <tbody class="pending_transactions_data"></tbody>
            </table>
        `)

    cache_pending = pending;
    for (var i = 0; i < pending.length;i++) {

        var new_element = `<tr data-pending-transaction-id="${pending[i].bank_pending_transaction_id}"><td>${pending[i].pending_trasaction_date}</td><td>${pending[i].bank_account_name}</td><td>$${pending[i].amount}</td><td>${!pending[i].current}</td></tr>`
        $(".pending_transactions_data").append(new_element);

    }
    //$('#pending_transaction_table').scrollTableBody({rowsToDisplay:4});

}

const bank_transaction_types = {1 : "ACH", 2 : "Withdrawal", 3 : "Deposit", 4 : "Wire Transfer"}

function populate_transactions(transactions) {

    $('.recent_transactions_table_div').html(
        `
            <table id="recent_transactions_table" class="table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Account</th>
                        <th>Amount</th>
                        <th>Type</th>
                    </tr>
                </thead>
                <tbody class="recent_transactions_data"></tbody>
            </table>
        `)

    cache_transactions = transactions;
    for (var i = 0; i < transactions.length; i++) {

        var transaction_type = bank_transaction_types[transactions[i].transaction_type_id]
        var new_element = `<tr><td>${transactions[i].transaction_date}</td><td>${transactions[i].bank_account_name}</td><td>$${transactions[i].amount}</td><td>${transaction_type}</td></tr>`
        $(".recent_transactions_data").append(new_element)

    }

}

function display() {

    $(".container-background").fadeIn();

}

function empty_out_data() {

    $(".accounts-dropdown").empty();

}

function hide() {

    empty_out_data();
    $(".container-background").fadeOut();

}

function set_welcome_name(name) {

    $('.welcome-navbar-item').text(name + "!");

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

    populate_transactions([
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 100,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 1
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 200,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 2
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 100,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 1
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 200,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 2
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 100,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 1
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 200,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 2
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 100,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 1
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 200,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 2
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 100,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 1
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 200,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 2
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 100,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 1
        },
        {
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 200,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 2
        }
    ]);
    populate_pending([

        {
            "bank_account_name": "bank_account_name",
            "bank_pending_transaction_id":1,
            "pending_trasaction_date": "10-11-2021",
            "reason": "Because",
            "amount": 100,
            "amount_left": 120,
            "current": true
        },
        {
            "bank_account_name": "bank_account_name",
            "bank_pending_transaction_id":2,
            "pending_trasaction_date": "10-11-2021",
            "reason": "Because Yes",
            "amount": 100,
            "amount_left": 100,
            "current": false
        },
        {
            "bank_account_name": "bank_account_name",
            "bank_pending_transaction_id":1,
            "pending_trasaction_date": "10-11-2021",
            "reason": "Because",
            "amount": 100,
            "amount_left": 120,
            "current": true
        },
        {
            "bank_account_name": "bank_account_name",
            "bank_pending_transaction_id":2,
            "pending_trasaction_date": "10-11-2021",
            "reason": "Because Yes",
            "amount": 100,
            "amount_left": 100,
            "current": false
        },
        {
            "bank_account_name": "bank_account_name",
            "bank_pending_transaction_id":1,
            "pending_trasaction_date": "10-11-2021",
            "reason": "Because",
            "amount": 100,
            "amount_left": 120,
            "current": true
        },
        {
            "bank_account_name": "bank_account_name",
            "bank_pending_transaction_id":2,
            "pending_trasaction_date": "10-11-2021",
            "reason": "Because Yes",
            "amount": 100,
            "amount_left": 100,
            "current": false
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

    $('tr').click(function() {

        console.log(this)

    })

    window.addEventListener("message", function (event) {

        if (event.data.display) {

            display();
            set_welcome_name(event.data.name);

        } else if (event.data.populate_accounts) {

            populate_accounts(event.data.accounts);

        } else if (event.data.populate_pending) {

            populate_pending(event.data.pending);

        } else if (event.data.populate_transactions) {

            populate_transactions(event.data.transactions)

        } else if (!event.data.display) {


        }

    })

})