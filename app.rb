require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbarshop.db"

class Client < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :phone, uniqueness: true
end

class Barber < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :phone, uniqueness: true 
end

class Visit < ActiveRecord::Base
end

before do
  @barbers = Barber.order 'name ASC'
end

get '/' do
  @barbers = Barber.order 'name'
  erb :barbers
end

get '/admin' do
  @barbers = Barber.order 'name ASC'
  @visits = Visit.all
  @b = Barber.new
  erb :admin
end

post '/admin' do
  @visits = Visit.all
  
  @b = Barber.new params[:barber]
  unless @b.save
    @error = @b.errors.full_messages.join ', '
    return erb :admin
  end
  
  erb :admin
end

get '/visit' do
  @barber_id = 0
  @barbers = Barber.order 'name ASC'
  @client = Client.new
  @visit = Visit.new
  erb :visit
end

post '/visit' do
  @visit = Visit.new params[:visit]
  @client = Client.find_by :phone => params[:client][:phone]
  if @client && @client.name != params[:client][:name]  
    @error = "This phone number: #{params[:client][:phone]} belongs another user"
    return erb :visit
  end 
  
  unless @client
    @client = Client.new params[:client]
    if @client.invalid?
      @error = @client.errors.full_messages.join ', '
      return erb :visit
    end
    @client.save
  end
  
  params[:visit][:client_id] = @client.id
  @visit = Visit.new params[:visit]
  if @visit.invalid?
    @error = @visit.errors.full_messages.join ', '
    return erb :visit
  end
  @visit.save
                        
  barber = Barber.find params[:visit][:barber_id]
  
  @message = "Dear #{@client.name} we'll waiting for you at #{@date_time} to barber #{barber.name}. You may contact phone: #{barber.phone}"
  erb :visit
end

get '/barber/:id' do  
  @barber = Barber.find params[:id]
  erb :barberinfo
end
