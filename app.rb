require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"person" TEXT,
			"color" TEXT
		)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = "something wrong"
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username  	= params[:username]
	@phone  	= params[:phone]
	@date_time 	= params[:date_time]
	@person		= params[:person]
	@color		= params[:color_picker]

	hh = { :username => 'Enter your name',
		   :phone => 'Enter your phone',
		   :date_time => 'Enter date and time'}

	hh.each do |key,value|
		if 	params[key] == ''
			@error = hh[key]
			return erb :visit
		end
	end

	f = File.open("./public/users.txt", "a") 
	f.write("User: #{@username} Phone: #{@phone} Date and Time: #{@date_time} Person: #{@person} Color: #{@color}\n");
	f.close;

	erb :visit
end