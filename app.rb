require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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

	if @username == ''
		@error = 'Enter your name'		
	end

	if @phone == ''
		@error = 'Enter your phone'
	end

	if @date_time == ''
		@error = 'Enter date and time visit'
	end
	

	if error != ''
		return erb :visit
	end

	f = File.open("./public/users.txt", "a") 
	f.write("User: #{@username} Phone: #{@phone} Date and Time: #{@date_time} Person: #{@person} Color: #{@color}\n");
	f.close;

	erb :visit
end