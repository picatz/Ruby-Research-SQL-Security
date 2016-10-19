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
#█▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀█
# 
# Author::    Kent 'picat' Gruber
# Copyright:: Copyright (c) 2016 Kent Gruber
# License::   MIT

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
# To parse config
require 'yaml'


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

  helpers do
    @db_creds = YAML.load_file('configs/mysql_credentials.yaml')
    $db = Mysql.new @db_creds['Host'], @db_creds['User']
    $db.select_db("IA480")


    def get_user_password(params)
      password = false
      result = $db.query("SELECT password FROM users WHERE user_name='#{params["user_name"]}'")
      result.each{ |p| password = p }
      password ? password[0] : password
    end

    def user_login(params)
      password = get_user_password(params)
      if password
        password == params["password"] ? true : false
      else
        false
      end
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
  end

  get '/' do
    erb :index
  end

  error do
    "THIS ERROR, IT IS XSTRM!"
  end

  not_found do
    halt 404, "Whoops! That ain't a thang."
  end

  post '/login' do
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

  get '/login' do
    erb :login
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
