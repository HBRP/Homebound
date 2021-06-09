
function open_gender_tile(event)
{

    $("#vitals_panel").fadeIn(4000)
    if (event.data.gender == "male") {

        $("#male_body").fadeIn(2500)
        $("#female_body").hide()

    } else {

        $("#male_body").hide()
        $("#female_body").fadeIn(2500)

    }

}

function open_panel(event)
{

    open_gender_tile(event)

}

function hide_everything()
{

    $("#male_body").hide()
    $("#female_body").hide()
    $("#wounds_panel").hide()
    $("#vitals_panel").hide()

}


function nui_event(event)
{
    if (event.data.type == "open_panel") {

        gender = event.data.gender
        open_panel(event)

    }
}

function keyboard_handler() 
{
    switch (event.key) {

        case "Escape":
            hide_everything()
            $.post("http://car-fob/EscapeCarFob", JSON.stringify({}))
            break;

    }
}

$(function() 
{

    hide_everything()
    open_gender_tile({"data":{"gender":"male"}})
    window.addEventListener('message', nui_event)
    window.addEventListener('keydown', keyboard_handler)

})