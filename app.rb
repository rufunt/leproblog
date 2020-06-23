
require 'rubygems'
require 'sinatra'


get '/' do
	erb "Hello!"		
end

get '/new' do
  erb :new
end

post '/new' do
	@content = params[:content]
	erb :new
end