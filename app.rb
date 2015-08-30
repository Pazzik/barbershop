require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return  db
end

def is_barber_exist? db,person
	db.execute('select * from Persons where person=?',[person]).length > 0
end

def seed_db db, persons
	persons.each do |person|
		unless is_barber_exist? db,person
			db.execute 'INSERT INTO	Persons	(person) values(?)',person
		end
	end	
end

before do
	db = get_db
	@persons = db.execute 'select * from Persons'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"person" TEXT,
			"color" TEXT
		)'
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Persons"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"person" TEXT
		)'
	
	seed_db db, ['Walter White','Jessie Pinkman','Gus Fring']
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

get '/showusers' do
	@users = []
	db = get_db
	db.execute 'select * from Users order by id desc' do |row|
		@users << row
	end
	erb :showusers
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

	db = get_db
	db.execute 'INSERT INTO
	 			Users 
	 			(
	 				username, 
	 				phone, 
	 				datestamp, 
	 				person, 
	 				color
	 			)
				values(?,?,?,?,?)', [@username,@phone,@date_time,@person,@color]

	f = File.open("./public/users.txt", "a") 
	f.write("User: #{@username} Phone: #{@phone} Date and Time: #{@date_time} Person: #{@person} Color: #{@color}\n");
	f.close;

	erb :visit
end

