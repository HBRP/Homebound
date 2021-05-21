
var cache_accounts     = []
var cache_pending      = []
var cache_transactions = []

var cash_on_hand = 0
var current_bank_account_id = 0

function get_current_funds() {

    for (var i = 0; i < cache_accounts.length;i++) {

        if (current_bank_account_id == cache_accounts[i].bank_account_id) {

            return cache_accounts[i].funds;

        }

    }

}

function deposit_button_click() {

    var value = $('.deposit-input').val()
    value = parseInt(value)
    if (isNaN(value) || value > cash_on_hand) {

        $('.deposit-input').addClass('is-danger')
        return;

    }
    $('.deposit-input').removeClass('is-danger')
    $('.deposit-input').val('')
    $('.deposit_money_modal').removeClass('is-active')
    $.post("http://em_bank/deposit_cash", JSON.stringify({ bank_account_id : current_bank_account_id, deposit_amount : value }));

}

function deposit_cancel_click() {

    $('.deposit-input').removeClass('is-danger')
    $('.deposit-input').val('')
    $('.deposit_money_modal').removeClass('is-active')

}

function withdraw_button_click() {

    var value = $('.withdraw-input').val();
    var funds = get_current_funds();

    value = parseInt(value)

    if (isNaN(value) || value > funds) {

        $('.withdraw-input').addClass('is-danger')
        return;

    }
    $('.withdraw-input').removeClass('is-danger')
    $('.withdraw-input').val('')
    $('.withdraw_money_modal').removeClass('is-active')
    $.post("http://em_bank/withdraw_cash", JSON.stringify({ bank_account_id : current_bank_account_id, withdraw_amount : value }));

}

function transfer_button_button() {

    var amount_value = $('.transfer-amount-input').val();
    var bank_account_id_value = $('.transfer-bankaccount-input').val();
    var reason = $('.transfer-reason-input').val();
    var funds = get_current_funds();

    amount_value = parseInt(amount_value)
    if (isNaN(amount_value) || amount_value > funds) {

        $('.transfer-amount-input').addClass('is-danger')
        return;

    }
    $('.transfer-amount-input').removeClass('is-danger')

    bank_account_id_value = parseInt(bank_account_id_value)
    if (isNaN(bank_account_id_value)) {

        $('.transfer-bankaccount-input').addClass('is-danger')
        return;

    }

    $('.transfer-bankaccount-input').removeClass('is-danger')
    $('.transfer-modal').removeClass('is-active')

    $.post("http://em_bank/transfer_amount", JSON.stringify({
        amount : amount_value,
        to_bank_account_id : bank_account_id_value,
        from_bank_account_id : parseInt(current_bank_account_id),
        reason: reason
    }))

}

function transfer_cancel_button() {

    $('.transfer-modal').removeClass('is-active')
    $('.transfer-amount-input').val('')
    $('.transfer-bankaccount-input').val('')
    $('.transfer-reason-input').val('')

    $('.transfer-amount-input').removeClass('is-danger')
    $('.transfer-bankaccount-input').removeClass('is-danger')

}

function withdraw_cancel_button() {

    $('.withdraw-input').removeClass('is-danger')
    $('.withdraw-input').val('')
    $('.withdraw_money_modal').removeClass('is-active')

}

function modal_clicks() {

    $('.deposit-button').click(deposit_button_click)
    $('.deposit-cancel-button').click(deposit_cancel_click)
    $('.withdraw-button').click(withdraw_button_click)
    $('.withdraw-cancel-button').click(withdraw_cancel_button)
    $('.make-transfer-button').click(transfer_button_button)
    $('.transfer-modal-close').click(transfer_cancel_button)

}

function load_account(bank_account_id) {

    current_bank_account_id = bank_account_id

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

        $('.transfer-modal').addClass('is-active')

    })

    $('.delete_button').click(function() {



    })

}

function populate_accounts(accounts) {

    cache_accounts = accounts;

    $('.accounts-dropdown').empty();
    
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
        //test_populate();
        $.post("http://em_bank/load_bank", JSON.stringify({bank_account_id : current_bank_account_id}))
        load_account(bank_account_id);
        setup_modal_table_clicks();

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

        var new_element = `<tr class="table-record" data-pending-transaction-id="${pending[i].bank_pending_transaction_id}"><td>${pending[i].pending_trasaction_date}</td><td>${pending[i].bank_account_name}</td><td>$${pending[i].amount}</td><td>${!pending[i].current}</td></tr>`
        $(".pending_transactions_data").append(new_element);

    }

}

const bank_transaction_types = 
    {
        1 : "ACH", 
        2 : "Withdrawal", 
        3 : "Deposit", 
        4 : "Wire Transfer", 
        5 : "Payment"
    }

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
        var new_element = `<tr class="table-record" data-transaction-id="${transactions[i].bank_transaction_id}"><td>${transactions[i].transaction_date}</td><td>${transactions[i].bank_account_name}</td><td>$${transactions[i].amount}</td><td>${transaction_type}</td></tr>`
        $(".recent_transactions_data").append(new_element)

    }

}

function display() {

    setTimeout(function() {

        $('.loading_screen').fadeOut(450);
        setTimeout(function() {
            $('.main_app').fadeIn();
            setup_modal_table_clicks();
        }, 500)

    }, 3000)

}

function hide() {

    $(".container-background").fadeOut();
    $('.transaction-modal').removeClass('is-active');
    $('.pending-transactions-modal').removeClass('is-active');
    $('.transfer-modal').removeClass('is-active');

}

function set_welcome_name(name) {

    $('.welcome-navbar-item').html(`<b>Welcome, ${name}!</b>`);

}

function set_cash_on_hand(cash) {

    cash_on_hand = cash
    $('.cash_on_hand').text(`You have $${cash} available to deposit.`)

}

function test_populate() {

    set_welcome_name("Test Customer")
    set_cash_on_hand(1000)
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
            "bank_transaction_id": 1,
            "bank_account_name": "bank_account_name",
            "reason": "reason",
            "amount": 100,
            "transaction_date": "10-11-2021",
            "transaction_type_id": 1
        },
        {
            "bank_transaction_id": 2,
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
        }

    ]);
    display();

}

function home_navbar_item_click() {

    $('.summary_box').show();
    $('.account_summary_box').hide();
    $('.account_actions_box').hide();
    //test_populate();
    $.post("http://em_bank/refresh_bank", JSON.stringify({}))
    setup_modal_table_clicks();

}

function setup_modal_table_clicks() {

    $('.table-record').click(record_click)
    $('.transaction-modal-close').click(function() {
        $('.transaction-modal').removeClass('is-active');
    })
    $('.pending-transactions-modal-close').click(function() {
        $('.pending-transactions-modal').removeClass('is-active');
    })

}

function handle_bank_transaction_click(bank_transaction_id) {

    for (var i = 0; i < cache_transactions.length;i++) {

        if (cache_transactions[i].bank_transaction_id == bank_transaction_id) {

            var transaction = cache_transactions[i]
            $('.transaction-modal-title').text(`Transaction Reference #${transaction.bank_transaction_id}`);
            $('.transaction-modal-body').html(
                `
                <p><b>Description</b>: ${transaction.reason}</p>
                <p><b>Transaction Amount:</b> ${transaction.amount}<p>
                <p><b>Transaction Date:</b> ${transaction.transaction_date}</p>
                <p><b>Transaction Type:</b> ${bank_transaction_types[transaction.transaction_type_id]}</p>
                `)
            $('.transaction-modal').addClass('is-active');

            break;
        }

    }

}

/*
    bank_account_name: String,
    bank_account_id: i32,
    bank_pending_transaction_id: i32,
    pending_transaction_date: String,
    reason: String,
    amount: i32,
    amount_left: i32,
    current: bool
*/

function pending_transaction_make_payment(pending_transaction) {

    var value = $('.pending-transaction-amount-input').val();
    value = parseInt(value);
    if (isNaN(value) || value > pending_transaction.amount_left) {

        $('.pending-transaction-amount-input').addClass('is-danger');
        return;

    }

    $('.pending-transaction-amount-input').removeClass('is-danger');
    $('.pending-transaction-amount-input').val('');
    $('.pending-transactions-modal').removeClass('is-active');
    $.post("http://em_bank/post_payment", JSON.stringify({amount : value, bank_account_id: pending_transaction.bank_account_id, bank_pending_transaction_id: pending_transaction.bank_pending_transaction_id }));

}

function handle_pending_transaction_click(bank_pending_transaction_id) {

    for (var i = 0; i < cache_pending.length;i++) {

        if (cache_pending[i].bank_pending_transaction_id == bank_pending_transaction_id) {

            var pending = cache_pending[i];
            $('.pending-transactions-modal-title').text(`Pending Transaction Reference #${pending.bank_pending_transaction_id}`);
            $('.pending-transactions-modal-body').html(
            `
                <p><b>Account Name:</b> ${pending.bank_account_name}</p>
                <p><b>Description:</b> ${pending.reason}</p>
                <p><b>Amount Due Now:</b> $${pending.amount}</p>
                <p><b>Total Amount Due:</b> $${pending.amount_left}</p>
                <p><b>Past Due: </b> ${!pending.current}</p>
                <br/>
                <p><b>Make a Payment</b><p>
                <br/>
                <input class="input is-rounded pending-transaction-amount-input" type="text" placeholder="Payment Amount">
            `)

            $('.pending-transactions-modal').addClass('is-active');
            $('.pending-transaction-make-payment').click(function() {
                pending_transaction_make_payment(pending)
            })

        }

    }

}

function record_click() {

    var bank_transaction_id = $(this).attr('data-transaction-id');
    var pending_transaction_id = $(this).attr('data-pending-transaction-id');
    if (bank_transaction_id != null) {

        handle_bank_transaction_click(bank_transaction_id);

    } else if (pending_transaction_id != null) {

        handle_pending_transaction_click(pending_transaction_id);

    }

}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function loading_screen() {

    $(".container-background").fadeIn();
    $('.loading_screen').show();
    $('.main_app').hide();

    const loading_text = [
        "Investing in Doge Coin",
        "Auditing your accounts",
        "Spending all your cash",
        "Rebooting for maintenance",
        "Is this thing down again?",
        "Rated the best banking app, by no one!",
        "Scrubbing scandalous transactions",
        "You should hire an accountant",
        "Are we there yet?",
        "Give me your money!",
        "Getting robbed again!",
        "If money doesn't grow on trees, then why do banks have branches?",
        "If money talks, why do we need bank tellers?",
        "Scandalizing the public",
        "Tickling fancies",
        "Burning bridges",
        "Drawing conclusions",
        "Contemplating the universe",
        "Deliberately Stalling",
        "Pretending to load",
        "Finding your money...",
        "Pretending we didn't gamble away your savings",
        "Sign up for our money laundering service!",
        "Wait, you wanted your money back?!",
        "Closing down and running away with your money!",
        "Money? What's Money?",
        "And it's gone..."
    ]

    for (var i = 0; i < 10;i++) {

        await sleep(i * 1000);
        $('.loading-text').text(loading_text[Math.floor(Math.random() * loading_text.length)]);

    }

}

$(function() {

    //test_populate();
    //loading_screen();

    modal_clicks();
    setup_modal_table_clicks();
    $('.home-navbar-item').click(home_navbar_item_click)

    window.addEventListener("message", function (event) {

        if (event.data.display) {

            display();
            set_welcome_name(event.data.name);

        } else if (event.data.populate_cash) {

            set_cash_on_hand(event.data.cash);

        } else if (event.data.populate_accounts) {

            populate_accounts(event.data.accounts);

        } else if (event.data.populate_pending) {

            populate_pending(event.data.pending);
            setup_modal_table_clicks();

        } else if (event.data.populate_transactions) {

            populate_transactions(event.data.transactions)
            setup_modal_table_clicks();

        } else if (event.data.show_loading) {

            loading_screen();

        } else if (!event.data.display) {


        }

    })

    $("body").on("keyup", function (key) {
        if (key.which == 27) {
            hide()
            $.post("http://em_bank/hide", JSON.stringify({}));
        }
    });

})