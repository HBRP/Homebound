var selected_area = null
function set_highlight_hover() {

    $("area").hover(function() {
        $(this).mapster("highlight", true)
    }, function() {
        $(this).mapster("highlight", false)
    })

}

function set_wounds_fadein() {

    $("map[name=male-map] area").on('click', function () {
        $("#wounds_panel").fadeIn()
        selected_area = this;
    });

    $("map[name=female-map] area").on('click', function () {
        $("#wounds_panel").fadeIn()
        selected_area = this;
    });

    $("#wounds_panel_close").on('click', function() {
        if (selected_area != null) {

            $(selected_area).mapster("highlight", false)
            $(selected_area).mapster("deselect", false)
            selected_area = null

        }
        $("#wounds_panel").fadeOut()               
    })

}

$(function() {
    $('img').mapster({
      fillColor: '0000ff',
      strokeColor: '0000ff',
      stroke: true,
      singleSelect: true,
      strokeWidth: 2,
     fillOpacity: 0.2
    });

    set_highlight_hover()
    set_wounds_fadein()

})