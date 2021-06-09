

function twitter_login_async(callback, username, password)

	password = tostring(password)
	trigger_server_callback_async("em_dal:twitter_login", callback, username, password)

end

function twitter_create_account_async(callback, username, password, avatar_url)

	password = tostring(password)
	trigger_server_callback_async("em_dal:twitter_create_account", callback, username, password, avatar_url)

end

function twitter_get_tweets_async(callback)

	trigger_server_callback_async("em_dal:twitter_get_tweets", callback)

end

function twitter_get_favourite_tweets_async(callback)

	trigger_server_callback_async("em_dal:twitter_get_favourite_tweets", callback)

end

function twitter_post_tweet_async(callback, message)

	trigger_server_callback_async("em_dal:twitter_post_tweet", callback, message)

end

function twitter_toggle_like_async(callback, phone_tweet_id)

	trigger_server_callback_async("em_dal:twitter_toggle_like", callback, phone_tweet_id)

end

function twitter_change_avatar_async(callback, username, password, avatar_url)

	password = tostring(password)
	trigger_server_callback_async("em_dal:twitter_change_avatar", callback, username, password, avatar_url)

end

function twitter_change_password_async(callback, username, password, new_password)

	password = tostring(password)
	new_password = tostring(new_password)
	trigger_server_callback_async("em_dal:twitter_change_password", callback, username, password, new_password)

end

function twitter_get_logged_in_account_async(callback)

	trigger_server_callback_async("em_dal:twitter_get_logged_in_account", callback)

end