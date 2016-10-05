require 'yaml'
require 'mysql'

@db_creds = YAML.load_file('configs/mysql_credentials.yaml')
$db = Mysql.new @db_creds['Host'], @db_creds['User']
$db.select_db("IA480")

def get_user_password(params)
	password = false
	result = $db.query("SELECT password FROM users WHERE user_name='#{params["user_name"]}'")
	result.each{ |p| password = p }
	password ? password[0] : password
end

def get_user_first_name(session)
	result = $db.query("SELECT first_name FROM users WHERE user_name='#{session["user_name"]}'")
	first_name = nil
	result.each { |x| first_name = x }
	first_name[0]
end

def get_user_last_name(session)
	result = $db.query("SELECT last_name FROM users WHERE user_name='#{session["user_name"]}'")
	last_name = nil
	result.each { |x| last_name = x }
	last_name[0]
end
