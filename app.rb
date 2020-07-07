require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'lepra.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
  init_db
  @db.execute 'create table if not exists Posts
  (
    id integer primary key autoincrement, 
    created_date date, 
    content text
  )' 
  
  @db.execute 'create table if not exists Comments
  (
    id integer primary key autoincrement, 
    created_date date, 
    content text,
    post_id integer
  )'
end


get '/' do
  @posts = @db.execute 'select * from posts order by id desc'
	erb :index		
end

get '/new' do
  erb :new
end

post '/new' do
  @content = params[:content]
  
  if @content.length < 1
    @error = "Type post text"
    return erb :new
  end

  @db.execute 'insert into Posts (content, created_date) values (?, datetime())', [@content]

	redirect to '/'
end

get '/details/:post_id' do
  post_id = params[:post_id]

  posts = @db.execute 'select * from posts where id = ?', [post_id]
  @result = posts[0]

  @comments = @db.execute 'select * from comments where post_id = ?', [post_id]
  
  erb :details
end

post '/details/:post_id' do
  post_id = params[:post_id]

  @content = params[:content]
  
  if @content.length < 1
    
    redirect to('/details/'+ post_id)
  end

  @db.execute 'insert into Comments 
    (
      content, 
      created_date,
      post_id
    ) values 
    (
      ?, datetime(), ?
    )', [@content, post_id]

    redirect to('/details/'+ post_id) 
end