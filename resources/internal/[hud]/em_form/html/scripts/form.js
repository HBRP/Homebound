var current_form;
var unique_id = 0;
function add_dropdown_menu(idx, menu) {
    $('.input-container').append("\n\t\t<div class=\"dropdown dropdown-" + idx + "\">\n\t\t  \t<div class=\"dropdown-trigger\">\n\t\t    \t<button class=\"button\" aria-haspopup=\"true\" aria-controls=\"dropdown-menu\">\n\t\t      \t<span class='selected-input-" + idx + "'>" + menu.input_name + "</span>\n\t\t      \t<span class=\"icon is-small\">\n\t\t        \t<i class=\"fas fa-angle-down\" aria-hidden=\"true\"></i>\n\t\t      \t</span>\n\t\t    \t</button>\n\t\t  \t</div>\n\t\t\t<div class=\"dropdown-menu input-" + idx + "\" role=\"menu\">\n\t\t\t    <div class=\"dropdown-content dropdown-content-" + idx + "\"></div>\n\t\t\t</div>\n\t\t</div>\n\t\t");
    for (var i = 0; i < menu.options.length; i++) {
        if (i == 0) {
            $(".dropdown-content-" + idx).append("<a class=\"dropdown-item dropdown-item-" + idx + " is-active\" style=\"text-align:left;\">" + menu.options[i] + "</a>");
        }
        else {
            $(".dropdown-content-" + idx).append("<a class=\"dropdown-item dropdown-item-" + idx + "\" style=\"text-align:left;\">" + menu.options[i] + "</a>");
        }
    }
    $(".dropdown-" + idx).click(function () {
        $(".dropdown-" + idx).toggleClass('is-active');
    });
    $(".dropdown-item-" + idx).click(function () {
        $(".dropdown-item-" + idx).removeClass('is-active');
        $(this).addClass('is-active');
    });
}
function add_text_input(idx, input) {
    $('.input-container').append("\n\t\t<div class=\"field\">\n\t\t\t<label class=\"label\">" + input.input_name + "</label>\n\t\t\t<div class=\"control\">\n\t\t\t\t<input class=\"input input-" + idx + "\" placeholder=\"" + input.placeholder + "\">\n\t\t\t</div>\n\t\t</div>\t\n\t");
}
function generate_form(title, form) {
    current_form = form;
    for (var i = 0; i < form.length; i++) {
        if (form[i].input_type == "text_input") {
            add_text_input(i, form[i]);
        }
        else if (form[i].input_type == "dropdown") {
            add_dropdown_menu(i, form[i]);
        }
    }
    $('.form-title').html("<b>" + title + "</b>");
}
function parse_text_input(idx, form) {
    var successful = false;
    var input = $(".input-" + idx).val().toString();
    if (!form.optional && input.length == 0) {
        return [false, 0];
    }
    if (!form.numbers_valid) {
        if (/\d/g.test(input)) {
            return [false, 0];
        }
    }
    if (!form.characters_valid) {
        if (/[a-zA-Z]/g.test(input)) {
            return [false, 0];
        }
    }
    return [true, input];
}
function parse_dropdown_selection(idx, form) {
    for (var i = 0; i < form.options.length; i++) {
        if ($(".dropdown-item-" + idx)[i].classList.contains("is-active")) {
            return [true, $(".dropdown-item-" + idx)[i].innerText];
        }
    }
    return [false, 0];
}
function submit() {
    var found_problem = false;
    var inputs = [];
    for (var i = 0; i < current_form.length; i++) {
        $(".input-" + i).removeClass('is-danger');
        if (current_form[i].input_type == "text_input") {
            var parsed = parse_text_input(i, current_form[i]);
            if (!parsed[0]) {
                $(".input-" + i).addClass('is-danger');
                found_problem = true;
                continue;
            }
            inputs.push({
                input_name: current_form[i].input_name,
                value: parsed[1]
            });
        }
        else if (current_form[i].input_type == "dropdown") {
            var parsed = parse_dropdown_selection(i, current_form[i]);
            if (!parsed[0]) {
                found_problem = true;
                continue;
            }
            inputs.push({
                input_name: current_form[i].input_name,
                value: parsed[1]
            });
        }
    }
    if (found_problem) {
        return;
    }
    $('.form-container').hide();
    $.post("http://em_form/submit", JSON.stringify(inputs));
}
function display() {
    $('.form-container').show();
}
function test_generate() {
    var temp_inputs = [
        {
            input_type: "text_input",
            input_name: "first_form",
            placeholder: "enter some text here",
            options: [],
            numbers_valid: true,
            characters_valid: false,
            optional: false
        },
        {
            input_type: "text_input",
            input_name: "second_form",
            placeholder: "enter some text here",
            options: [],
            numbers_valid: false,
            characters_valid: true,
            optional: false
        },
        {
            input_type: "text_input",
            input_name: "third_form",
            placeholder: "enter some text here",
            options: [],
            numbers_valid: true,
            characters_valid: true,
            optional: false
        },
        {
            input_type: "dropdown",
            input_name: "fourth_form",
            placeholder: "",
            options: ["first option", "second option", "third option"],
            numbers_valid: true,
            characters_valid: true,
            optional: false
        }
    ];
    $('.input-container').html('');
    generate_form('test title', temp_inputs);
    display();
}
$(function () {
    $('.cancel-button').click(function () {
        $('.form-container').hide();
        $.post("http://em_form/quit", JSON.stringify({}));
    });
    $('.submit-button').click(function () {
        submit();
    });
    //test_generate();
    window.addEventListener("message", function (event) {
        if (event.data.display) {
            $('.input-container').html('');
            generate_form(event.data.title, event.data.form);
            display();
        }
    });
});
