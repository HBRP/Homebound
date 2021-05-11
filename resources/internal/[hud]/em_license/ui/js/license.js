

function show_id(item_metedata) {

    $(".license_img").show("slide", {direction:"right"}, 1000, function() {

        $("#license_text").fadeIn();

    })

}

$(function() {


    show_id()
    window.addEventListener("message", function (event) {

        if (event.data.show_id) {

            show_id(event.data.item_metedata)

        }

    })

})