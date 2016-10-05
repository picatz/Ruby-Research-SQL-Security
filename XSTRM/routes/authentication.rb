require_relative 'mysql_helpers'

def user_login(params)
	password = get_user_password(params)
	if password
		password == params["password"] ? true : false
	else
		false
	end
end
