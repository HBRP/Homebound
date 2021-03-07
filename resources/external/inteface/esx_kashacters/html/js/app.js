$(function (){
    //$(".character-info-new").hide();
    $(".character-select").hide();
});

$(".wake-up").click(function (e) {
    $("#debug").html( $(e.target).attr("char") );
    $.post("http://esx_kashacters/CharacterChosen", JSON.stringify({
        charid: $(e.target).attr("char"),
        ischar: "true"
    }));
    Kashacter.CloseUI();
});

$(".character-info-new").click(function (e) {
    $("#debug").html( $(e.target).attr("char") );
    $.post("http://esx_kashacters/CharacterChosen", JSON.stringify({
        charid: $(e.target).attr("char"),
        ischar: "false"
    }));
    Kashacter.CloseUI();
});

$(".deletechar").click(function (e) {
    $("#debug").html( $(e.target).attr("char") );
    $.post("http://esx_kashacters/DeleteCharacter", JSON.stringify({
        charid: $(e.target).attr("char")
    }));
    location.reload();
    //Kashacter.CloseUI();
});

(() => {
    Kashacter = {};

    Kashacter.ShowUI = function(data) {
        $(".main-container").css({"display":"block"});
        if(data.characters !== null) {
            $.each(data.characters, function (index, char) {
                if (char.character_id !== 0) {
                    var charid = character_id;
                    //var date = new Date(char.created);
                    //var created = (date.getMonth()+1) + '/' + date.getDate() + '/' + date.getFullYear();
                    $('[data-charid=' + charid + '] .character-firstname').html(char.firstname);
                    $('[data-charid=' + charid + '] .character-lastname').html(char.lastname);
                    $('[data-charid=' + charid + '] .character-signature').html(char.firstname + ' ' + char.lastname);
                    $('[data-charid=' + charid + '] .character-job').html("");
                    $('[data-charid=' + charid + '] .character-dob').html(char.dob);
                    $('[data-charid=' + charid + '] .character-sex').html("char.sex");
                    $('[data-charid=' + charid + '] .character-height').html("");
                    $('[data-charid=' + charid + '] .character-issued').html("");
                    $('[data-charid=' + charid + ']').attr("data-ischar", "true");
                    $('[data-charid=' + charid + '] .character-info-new').hide();
                    $('[data-charid=' + charid + '] .character-select').show();
                    $('[data-charid=' + charid + ']').removeClass('character-container');
                    $('[data-charid=' + charid + ']').addClass('character-container-ischar');
                }
            });
        }
    };

    Kashacter.CloseUI = function() {
        $('.main-container').css({"display":"none"});
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
