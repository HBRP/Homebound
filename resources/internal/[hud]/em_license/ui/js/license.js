

function show_id(item_metadata) {

    $("#expiration")[0].innerHTML =  "<p>{}</p>".replace("{}", item_metadata.hidden.Expiration)
    $("#lastname")[0].innerHTML = "<p>{}</p>".replace("{}", item_metadata.hidden.Lastname)
    $("#firstname")[0].innerHTML = "<p>{}</p>".replace("{}", item_metadata.hidden.Firstname)
    $("#dob")[0].innerHTML = "<p>{}</p>".replace("{}", item_metadata.hidden.DOB)
    $("#gender")[0].innerHTML = "<p>{}</p>".replace("{}", item_metadata.hidden.Gender.charAt(0))
    $("#issued")[0].innerHTML = "<p>{}</p>".replace("{}", item_metadata.hidden.Issued)

    $(".license_img").show("slide", {direction:"right"}, 1000, function() {

        $("#license_text").fadeIn();
        $.post("http://em_license/license_hide", JSON.stringify({}));
        setTimeout(function() {

            $("#license_text").fadeOut();
            $(".license_img").fadeOut();

        }, 5000)

    })

}

$(function() {

    /*
    show_id({
        "hidden" : {
            "DOB" : "25/06/1994",
            "Expiration" : "03-08-2021",
            "Firstname" : "Amelia",
            "LastName" : "Knightly",
            "Gender" : "f",
            "Issued" : "11-05-2021"
        }
    })
    */
    window.addEventListener("message", function (event) {

        if (event.data.show_id) {

            show_id(event.data.item_metadata)

        }

    })

})