
interface FormInput {

	input_type: string,
	input_name: string,
	placeholder: string,
	options: string[],
	numbers_valid: boolean,
	characters_valid: boolean,
	optional: boolean

}

interface ParsedInput {

	input_name: string,
	value: any

}

let current_form: FormInput[];
let unique_id: number = 0;

function add_dropdown_menu(idx: number, menu: FormInput) {

	$('.input-container').append(
		`
		<div class="dropdown dropdown-${idx}">
		  	<div class="dropdown-trigger">
		    	<button class="button" aria-haspopup="true" aria-controls="dropdown-menu">
		      	<span class='selected-input-${idx}'>${menu.input_name}</span>
		      	<span class="icon is-small">
		        	<i class="fas fa-angle-down" aria-hidden="true"></i>
		      	</span>
		    	</button>
		  	</div>
			<div class="dropdown-menu input-${idx}" role="menu">
			    <div class="dropdown-content dropdown-content-${idx}"></div>
			</div>
		</div>
		`);

	for (var i = 0;i < menu.options.length; i++) {

		if (i == 0) {

			$(`.dropdown-content-${idx}`).append(`<a class="dropdown-item dropdown-item-${idx} is-active" style="text-align:left;">${menu.options[i]}</a>`);

		} else {

			$(`.dropdown-content-${idx}`).append(`<a class="dropdown-item dropdown-item-${idx}" style="text-align:left;">${menu.options[i]}</a>`);

		}

	}

	$(`.dropdown-${idx}`).click(function() {

		$(`.dropdown-${idx}`).toggleClass('is-active');

	})

	$(`.dropdown-item-${idx}`).click(function() {

		$(`.dropdown-item-${idx}`).removeClass('is-active');
		$(this).addClass('is-active');

	})


}

function add_text_input(idx: number, input: FormInput) {

	$('.input-container').append(
	`
		<div class="field">
			<label class="label">${input.input_name}</label>
			<div class="control">
				<input class="input input-${idx}" placeholder="${input.placeholder}">
			</div>
		</div>	
	`)

}

function add_radio_button(idx: number, input: FormInput) {

	$('.input-container').append(`<div class="control input-${idx}"></div>`);

	for (var i = 0; i < input.options.length; i++) {

		if (i == 0) {

			$(`.input-${idx}`).append(
			`
				<label class="radio">
					<input type="radio" name="answer" class="radio-${idx}-${i}" checked>
					${input.options[i]}
				</label>
			`);

		} else {

			$(`.input-${idx}`).append(
			`
				<label class="radio">
					<input type="radio" name="answer" class="radio-${idx}-${i}">
					${input.options[i]}
				</label>
			`)

		}

	}

}

function generate_form(title: string, form: FormInput[]) {

	current_form = form;
	for (var i = 0; i < form.length;i++) {

		if (form[i].input_type == "text_input") {

			add_text_input(i, form[i]);

		} else if (form[i].input_type == "dropdown") {

			add_dropdown_menu(i, form[i]);

		} else if (form[i].input_type == "radiobutton") {

			add_radio_button(i, form[i]);

		}

	}
	$('.form-title').html(`<b>${title}</b>`);

}

function parse_text_input(idx: number, form: FormInput) : [boolean, any] {

	let successful = false;
	let input: string = $(`.input-${idx}`).val().toString();

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

function parse_dropdown_selection(idx: number, form: FormInput) : [boolean, any] {

	for (var i = 0;i < form.options.length;i++) {

		 if ($(`.dropdown-item-${idx}`)[i].classList.contains("is-active")) {

		 	return [true, $(`.dropdown-item-${idx}`)[i].innerText]

		 }

	}

	return [false, 0];

}

function parse_radio_selection(idx: number, form: FormInput) : [boolean, any] {

	for (var i = 0; i < form.options.length;i++) {

		var attribute  = $(`.radio-${idx}-${i}`).attr('checked');
		if (attribute) {

			return [true, form.options[i]];

		}

	}

	return [false, 0];

}

function submit() {

	let found_problem = false;
	let inputs: ParsedInput[] = [];

	for (var i = 0; i < current_form.length; i++) {

		$(`.input-${i}`).removeClass('is-danger');
		if (current_form[i].input_type == "text_input") {

			let parsed = parse_text_input(i, current_form[i]);

			if (!parsed[0]) {

				$(`.input-${i}`).addClass('is-danger');
				found_problem = true;
				continue;

			}
			inputs.push({
				input_name: current_form[i].input_name,
				value: parsed[1]
			})


		} else if (current_form[i].input_type == "dropdown") {

			let parsed = parse_dropdown_selection(i, current_form[i]);
			if (!parsed[0]) {

				found_problem = true;
				continue;

			}
			inputs.push({
				input_name: current_form[i].input_name,
				value: parsed[1]
			})

		} else if (current_form[i].input_type == "radiobutton") {

			let parsed = parse_radio_selection(i, current_form[i]);
			if (!parsed[0]) {

				found_problem = true;
				continue;

			}
			inputs.push({
				input_name: current_form[i].input_name,
				value: parsed[1]
			})

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

	let temp_inputs: FormInput[] = [
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
		},
		{
			input_type: "radiobutton",
			input_name: "fifth_form",
			placeholder: "",
			options: ["first option", "second option", "third option"],
			numbers_valid: true,
			characters_valid: true,
			optional: false
		}
	]

	$('.input-container').html('');
	generate_form('test title', temp_inputs);
	display();

}


$(function() {

	$('.cancel-button').click(function() {

		$('.form-container').hide();
		$.post("http://em_form/quit", JSON.stringify({}));

	})

	$('.submit-button').click(function() {

		submit()

	})

	//test_generate();

	window.addEventListener("message", function (event) {

        if (event.data.display) {

        	$('.input-container').html('');
        	generate_form(event.data.title, event.data.form);
        	display();

        }
    })	
})