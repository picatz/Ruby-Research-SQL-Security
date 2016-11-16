require 'sinatra'

# Intended use:
# GET /xss?stuff=foo

# Vulnerable use:
# GET /xss?stuff=<script>alert(" [ ╯ ' □']╯︵ ┻━┻ ) ")</script>"

get '/xss' do
  if params[:stuff] 
    @stuff = params[:stuff]
  else
    @stuff = "Nothing for xss?stuff=" 
  end
  erb :reflected_xss 
end
