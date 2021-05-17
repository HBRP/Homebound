

function populate_accounts(accounts) {

    var element = '<a class="navbar-item" bank_account_id="{id}">({id}) {name}</a>'
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

function display() {

    $(".container-background").fadeIn();

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

}

$(function() {

    test_populate();

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