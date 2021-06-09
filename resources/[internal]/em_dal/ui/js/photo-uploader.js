
function upload_photo(data) {

	const http = new XMLHttpRequest()
	http.open("POST", data.endpoint + "/Photo/Upload")
	http.setRequestHeader('Content-type', 'application/json')
	http.send(JSON.stringify({photo: data.photo, "session_token": data.session_token}))

	http.onload = function() {

		var response = JSON.parse(http.responseText)
		response.id = data.id
		$.post("http://em_dal/em_dal_photo", JSON.stringify(response))

	}

}

$(function() {

    window.addEventListener("message", function (event) {

        if (event.data.upload_photo) {

        	upload_photo(event.data)

        }

    })

})