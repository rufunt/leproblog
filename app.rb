
require 'rubygems'
require 'sinatra'


get '/' do
	erb "Hello!"		
end

get '/new' do
  erb "Hello World"
end