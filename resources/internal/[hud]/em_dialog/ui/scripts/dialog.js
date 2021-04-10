

var current_dialog_options = null

function show_dialog(dialog_options) {

    current_dialog_options = dialog_options

    $(".dialog-options").empty();
    $(".dialog_options").show();
    for (var i = 0; i < dialog_options.length; i++) {

        $(".dialog-options").append('<div class="dialog-option"><button onclick="option_clicked({id})"><p>{dialog}</p></button></div>'.replace("{id}", i).replace("{dialog}", dialog_options[i].dialog));


    }

}

function dialog_listener() {

}

function option_clicked(id) {

    console.log(id)

}

function test_function() {

    var dialog = [
        {
            dialog : "I would like to buy stuff.",
            response : "Well fuck you, give me money",
            callback_id: 0
        },
        {
            dialog : "Fuck you asshole",
            response : "Well fuck you as well, bitch!",
            callback_id: 1
        }
    ]
    show_dialog(dialog)

}


$(function() {

    window.addEventListener("message", function (event) {
        if (event.data.display == "show_dialog") {

        }
    })
    dialog_listener()
    test_function()

})



