require 'sinatra/contrib'
require 'sinatra/reloader'

get '/' do
  'Version 1.2'
end

get '/cars' do
  'This is my car lists'
end