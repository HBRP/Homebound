

var current_dialog_options = null

function show_dialog(dialog_options) {

    $(".dialog-container").show();

    current_dialog_options = dialog_options

    $(".dialog-options").empty();
    $(".dialog_options").show();
    for (var i = 0; i < dialog_options.length; i++) {

        $(".dialog-options").append('<div class="dialog-option"><button onclick="option_clicked({id})"><p>{dialog}</p></button></div>'.replace("{id}", i).replace("{dialog}", dialog_options[i].dialog));


    }

}

function hide_elements() {

    $(".dialog_options").hide();
    $(".dialog-response").hide();
    $(".dialog-container").hide();

}

function option_clicked(id) {

    if (current_dialog_options[id].response != null) {

        $(".dialog-options").empty();
        $(".dialog_options").hide();

        $(".dialog-response").empty();
        $(".dialog-response").append('<p>{response}</p>'.replace("{response}", current_dialog_options[id].response))
        $(".dialog-response").show();

        var split = current_dialog_options[id].response.split(" ");
        var time_to_wait = split.length * 250

        setTimeout(function() { 

            $.post("http://em_dialog/callback_option", JSON.stringify({
                callback_id: current_dialog_options[id].callback_id
            }));

        }, time_to_wait);

    } else {

        $.post("http://em_dialog/callback_option", JSON.stringify({
            callback_id: current_dialog_options[id].callback_id
        }));

    }

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

            show_dialog(event.data.dialog);

        } else if (event.data.display == "hide") {

            hide_elements()

        }

    })
    dialog_listener()
    //test_function()

})



