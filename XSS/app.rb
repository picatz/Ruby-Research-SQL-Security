require 'sinatra'
require 'sinatra/cookies'

enable  :sessions

# Intended use:
# GET /session?stuff=foo

# Vulnerable use:
# GET /xss?stuff=<script>alert(" [ ╯ ' □']╯︵ ┻━┻ ) ")</script>
# GET /session?stuff=<script>alert(document.cookie)</script>

get '/xss' do
  if params[:stuff]
    response.set_cookie 'vulnerable', cookies["rack.session"]
    @stuff = params[:stuff]
  else
    @stuff = "Nothing."
  end
  erb :reflected_xss
end
