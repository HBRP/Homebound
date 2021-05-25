
interface FormInput {

	input_type: string,
	input_name: string,
	placeholder: string,
	options: string[],
	numbers_valid: boolean,
	characters_valid: boolean,

}

let current_form: FormInput[];
let unique_id: number = 0;

function add_dropdown_menu(idx: number, menu: FormInput) {

	$('.input-container').append(
		`
		<div class="dropdown is-active">
		  	<div class="dropdown-trigger">
		    	<button class="button" aria-haspopup="true" aria-controls="dropdown-menu">
		      	<span>Dropdown button</span>
		      	<span class="icon is-small">
		        	<i class="fas fa-angle-down" aria-hidden="true"></i>
		      	</span>
		    	</button>
		  	</div>
			<div class="dropdown-menu input-${idx}" role="menu">
			    <div class="dropdown-content dropdown-content-${idx}"></div>
			</div>
		</div>
		`)

	for (var i = 0;i < menu.options.length; i++) {

		$(`.dropdown-content-${idx}`).append(`<a class="dropdown-item">${menu.options[i]}</a>`)

	}


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

function generate_form(title: string, form: FormInput[]) {

	current_form = form;
	for (var i = 0; i < form.length;i++) {

		if (form[i].input_type == "text_input") {

			add_text_input(i, form[i]);

		} else if (form[i].input_type == "dropdown") {

			add_dropdown_menu(i, form[i]);

		}

	}
	$('.form-title').html(`<b>${title}</b>`);

}

function submit() {

	for (var i = 0; i < current_form.length; i++) {

		if (current_form[i].input_type == "text_input") {


		} else if (current_form[i].input_type == "dropdown") {



		}

	}

	//$('.form-container').hide();

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
	]

	$('.input-container').html('');
	generate_form('test title', temp_inputs);
	display();

}


$(function() {

	$('.cancel-button').click(function() {

		$('.form-container').hide();

	})

	$('.submit-button').click(function() {

		submit()

	})

	test_generate();

	window.addEventListener("message", function (event) {

        if (event.data.display) {

        	$('.input-container').html('');
        	generate_form(event.data.title, event.data.form);
        	display();

        }
    })	
})