	def existing_usernames
		Dir["private/accounts/*.yaml"].each.map {|f| YAML.load_file(f)["user_name"]}
	end

	def existing_emails
		Dir["private/accounts/*.yaml"].each.map {|f| YAML.load_file(f)["email"]}
	end
