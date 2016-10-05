require_relative 'authentication.rb'

module Sinatra
	module App
		module Routing
			module Sessions

				def self.registered(app)

					app.post '/login' do
						if user_login(params)
							session[:user_name] = params["user_name"]
							@session = session
							@user_first_name = get_user_first_name(session)
							@user_last_name = get_user_last_name(session)
							erb :win
						else
							@failed = true
							erb :login
						end	
					end

					app.get '/login' do
						erb :login
					end

				end
			end
		end
	end
end
