

register_server_callback("em_dal:twitter_login", function(source, callback, username, password)

	local data = {character_id = get_character_id_from_source(source), username = username, password = password}
	HttpPost("/Phone/Twitter/Login", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:twitter_create_account", function(source, callback, username, password, avatar_url)

	local data = {character_id = get_character_id_from_source(source), username = username, password = password, avatar_url = avatar_url}
	HttpPost("/Phone/Twitter/Create", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:twitter_get_tweets", function(source, callback)

	local endpoint = string.format("/Phone/Twitter/Tweets/%d", get_character_id_from_source(source))
	HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:twitter_get_favourite_tweets", function(source, callback)

    local endpoint = string.format("/Phone/Tweets/Favourites/%d", get_character_id_from_source(source))
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:twitter_post_tweet", function(source, callback, message)

    local data = {character_id = get_character_id_from_source(source), message = message}
    HttpPost("/Phone/Tweet/New", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:twitter_toggle_like", function(source, callback, phone_tweet_id)

    local endpoint = string.format("/Phone/Tweet/ToggleLike/%d/%d", get_character_id_from_source(source), phone_tweet_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:twitter_change_avatar", function(source, callback, username, password, avatar_url)

	local data = {username = username, password = password, avatar_url = avatar_url}
	HttpPost("/Phone/Twitter/ChangeAvatar", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:twitter_change_password", function(source, callback, username, password, new_password)

	local data = {username = username, password = password, new_password = new_password}
	HttpPost("/Phone/Twitter/ChangePassword", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:twitter_get_logged_in_account", function(source, callback)

	local endpoint = string.format("/Phone/Twitter/LoggedInAccount/%d", get_character_id_from_source(source))
	HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)