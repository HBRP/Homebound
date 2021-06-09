
var characters = null;

$(function (){
    //$(".character-info-new").hide();
    $(".character-select").hide();
});

$(".wake-up").click(function (e) {
    $("#debug").html( $(e.target).attr("char") );
    Kashacter.CloseUI();

    $('img').fadeOut(3000, "swing", function() {
        $.post("https://esx_kashacters/CharacterChosen", JSON.stringify({
            character_id: characters[$(e.target).attr("char") - 1].character_id
        }));
    })


});

$(".character-info-new").click(function (e) {

    Kashacter.OpenForm();

});

$("#create_character_button").click(function (e) {

    var gender = $("input[name='gender']:checked").val();
    if (!gender) {

    }

    var first_name = $("#first_name_text").val();
    var last_name  = $("#last_name_text").val();
    var birthday   = $("#birthday_text").val();

    if (first_name && first_name.length < 3) {

        return;

    }
    if (last_name && last_name.length < 3) {

        return;
        
    }
    if (birthday && birthday.length != 10) {

        return;
        
    }

    Kashacter.CloseUI();
    $('img').fadeOut(3000, "swing", function() {
        $.post("https://esx_kashacters/CreateCharacter", JSON.stringify({
            first_name: first_name,
            last_name: last_name,
            dob: birthday,
            gender: gender
        }));
    })

});

function reset_cards() {

    for (var i = 1; i < 9;i++) {

        $('[data-charid=' + i + '] .character-firstname').html("");
        $('[data-charid=' + i + '] .character-lastname').html("");
        $('[data-charid=' + i + '] .character-signature').html("");
        $('[data-charid=' + i + '] .character-job').html("");
        $('[data-charid=' + i + '] .character-dob').html("");
        $('[data-charid=' + i + '] .character-sex').html("");
        $('[data-charid=' + i + '] .character-height').html("");
        $('[data-charid=' + i + '] .character-issued').html("");
        $('[data-charid=' + i + ']').attr("data-ischar", "false");
        $('[data-charid=' + i + '] .character-info-new').show();
        $('[data-charid=' + i + '] .character-select').hide();
        $('[data-charid=' + i + ']').addClass('character-container');
        $('[data-charid=' + i + ']').removeClass('character-container-ischar');

    }

}

$(".deletechar").click(function (e) {
    $.post("https://esx_kashacters/DeleteCharacter", JSON.stringify({
        character_id: characters[$(e.target).attr("char") - 1].character_id
    }));
    Kashacter.CloseUI();
});

(() => {
    Kashacter = {};

    Kashacter.ShowUI = function(data) {
        $(".main-container").css({"display":"block"});
        
        if(data.characters == null) {
            return;
        }
        reset_cards();
        characters = data.characters
         $.each(characters, function (i, char) {
                var fake_char_id = i + 1
                $('[data-charid=' + fake_char_id + '] .character-firstname').html(char.first_name);
                $('[data-charid=' + fake_char_id + '] .character-lastname').html(char.last_name);
                $('[data-charid=' + fake_char_id + '] .character-signature').html(char.first_name + ' ' + char.last_name);
                $('[data-charid=' + fake_char_id + '] .character-job').html("");
                $('[data-charid=' + fake_char_id + '] .character-dob').html(char.dob);
                $('[data-charid=' + fake_char_id + '] .character-sex').html(char.gender);
                $('[data-charid=' + fake_char_id + '] .character-height').html("");
                $('[data-charid=' + fake_char_id + '] .character-issued').html("");
                $('[data-charid=' + fake_char_id + ']').attr("data-ischar", "true");
                $('[data-charid=' + fake_char_id + '] .character-info-new').hide();
                $('[data-charid=' + fake_char_id + '] .character-select').show();
                $('[data-charid=' + fake_char_id + ']').removeClass('character-container');
                $('[data-charid=' + fake_char_id + ']').addClass('character-container-ischar');
        });
    }

    Kashacter.CloseUI = function() {
        $('.main-container').css({"display":"none"});
        $("#form").css({"display":"none"});
    };
    Kashacter.OpenForm = function() {
        $('.main-container').css({"display":"none"});
        $("#form").show()
    };
    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case 'openui':
                    Kashacter.ShowUI(event.data);
                    break;
            }
        });
    };

})();
