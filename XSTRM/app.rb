#!/usr/bin/env ruby
#█▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀█          
#	       _  _ ____ _____ __  __  ___        _ _____ _  
#       | |/_/ __/_  __/ _ \/  |/  /        \/     \/
#      _>  <_\ \  / / / , _/ /|_/ /____     / ' _ ' \
#     /_/|_/___/ /_/ /_/|_/_/  /_/    /     \==_Y_==/
#     私は大きな声で歌います_________/       \_____/
#                                                           
# XSTRM is the  most extreme Ruby development platform ever!
# 
# XAMPP is a completely free, cross-patform, easy to 
# install toolset containing Sinatra, Thin, Ruby,
# and - because I had to for class - MySql. Extreme!
#
#█▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀█
# 
# Author::    Kent 'picat' Gruber
# Copyright:: Copyright (c) 2016 Kent Gruber
# License::   MIT

# Built with Debian in mind ( No shit, Kali linux I am using. )
# apt-get install mysql 
# apt-get mysql-client 
# apt-get mysql-server
# apt-get install libmysql-ruby
# apt-get install libmysqlclient15-dev
# 
# gem install mysql
# gem install colorize
# gem install lolize

# Require Gems
# Sinatra : a DSL for quickly creating web applications.
require 'sinatra/base'
# Thin    : A small and fast Ruby web server.
require 'thin'
# Logger  : a simple but sophisticated logging utility.
require 'logger'
# MySQLl  : MySQL API module for Ruby,
require 'mysql'
# To renbder out our 
require 'tilt/erubis'

# Require Custom, Extreme Files
require_relative 'xstrm'
require_relative 'helpers'
require_relative 'routes/main'
require_relative 'routes/sessions'
require_relative 'routes/errors'

# Main XSTRM class
class Xstrm < Sinatra::Base

	# Logging options for application.
	::Logger.class_eval { alias :write :'<<' }
	access_log = ::File.join(::File.dirname(::File.expand_path(__FILE__)),'log','access.log')
	access_logger = ::Logger.new(access_log)
	error_logger = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)),'log','error.log'),"a+")
	error_logger.sync = true

	before do
		env["rack.errors"] = error_logger
		headers["X-STRM"] = "XSTRM WEB APP DEVELOPMENT IS AFOOT!"
	end

	# Configurations for the application platform.
	configure do
		# Set Sinatra settings to specification.
		set :environment, :production
		set :bind, '0.0.0.0'
		set :port, 80
		set :server, :thin
		if server.respond_to? :threaded=
			server.threaded = settings.threaded 
		end
		set :root, File.dirname(__FILE__)
		use ::Rack::CommonLogger, access_logger
		enable :sessions
		# Require Sinatra Moduels 
		helpers  Sinatra::Helpers
		register Sinatra::App::Routing::Main
		register Sinatra::App::Routing::Sessions
		register Sinatra::App::Routing::Errors
	end

	# This method will start the application.
	def self.run!
		super do |server|
			# stuff before server is started
		end
	end
end

if __FILE__ == $0
	# When file is ran with ruby, run the Application
	Xstrm.run!
end
