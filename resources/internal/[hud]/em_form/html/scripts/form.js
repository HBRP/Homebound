var current_form;
var unique_id = 0;
function add_dropdown_menu(idx, menu) {
    $('.input-container').append("\n\t\t<div class=\"dropdown is-active\">\n\t\t  \t<div class=\"dropdown-trigger\">\n\t\t    \t<button class=\"button\" aria-haspopup=\"true\" aria-controls=\"dropdown-menu\">\n\t\t      \t<span>Dropdown button</span>\n\t\t      \t<span class=\"icon is-small\">\n\t\t        \t<i class=\"fas fa-angle-down\" aria-hidden=\"true\"></i>\n\t\t      \t</span>\n\t\t    \t</button>\n\t\t  \t</div>\n\t\t\t<div class=\"dropdown-menu input-" + idx + "\" role=\"menu\">\n\t\t\t    <div class=\"dropdown-content dropdown-content-" + idx + "\"></div>\n\t\t\t</div>\n\t\t</div>\n\t\t");
    for (var i = 0; i < menu.options.length; i++) {
        $(".dropdown-content-" + idx).append("<a class=\"dropdown-item\">" + menu.options[i] + "</a>");
    }
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
function submit() {
    for (var i = 0; i < current_form.length; i++) {
        if (current_form[i].input_type == "text_input") {
        }
        else if (current_form[i].input_type == "dropdown") {
        }
    }
    //$('.form-container').hide();
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
            characters_valid: false
        },
        {
            input_type: "text_input",
            input_name: "second_form",
            placeholder: "enter some text here",
            options: [],
            numbers_valid: false,
            characters_valid: true
        },
        {
            input_type: "text_input",
            input_name: "third_form",
            placeholder: "enter some text here",
            options: [],
            numbers_valid: true,
            characters_valid: true
        },
        {
            input_type: "dropdown",
            input_name: "fourth_form",
            placeholder: "",
            options: ["first option", "section option"],
            numbers_valid: true,
            characters_valid: true
        }
    ];
    $('.input-container').html('');
    generate_form('test title', temp_inputs);
    display();
}
$(function () {
    $('.cancel-button').click(function () {
        $('.form-container').hide();
    });
    $('.submit-button').click(function () {
        submit();
    });
    test_generate();
    window.addEventListener("message", function (event) {
        if (event.data.display) {
            $('.input-container').html('');
            generate_form(event.data.title, event.data.form);
            display();
        }
    });
});
