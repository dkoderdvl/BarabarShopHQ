require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
#require 'sqlite3'

set :database, "sqlite3:barbarshop.db"

class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base
end

class Visit < ActiveRecord::Base
end



get '/' do
  erb 'Hi!'
end

get '/admin' do
  @barbers = Barber.order 'name ASC'
  @visits = Visit.all
  
  erb :admin
end

post '/admin' do
  barber_name = params[:barber_name]
  barber_phone = params[:barber_phone]
  
  # TODO Тут нужна валидация
  
  @barbers = Barber.order 'name ASC'
  @visits = Visit.all
  
  barber = Barber.find_or_initialize_by phone: barber_phone
  if barber.persisted? && barber.name != barber_name
    @error = "OOOPs!!! A barber with this phone number #{barber_phone} is already there. This is #{barber.name}."
    @barbers = Barber.order 'name ASC'
    return erb :admin
  end
  
  if barber.new_record?
    barber.name = barber_name 
    barber.phone = barber_phone
    barber.save
    
    @message = "New barber added. Name: #{barber.name}, phone: #{barber.phone}"
  end
  
 erb :admin
end

get '/visit' do
  @barber_id = 0
  @barbers = Barber.order 'name ASC'
  
  erb :visit
end

post '/visit' do
  @barber_id = 0
  @barbers = Barber.order 'name ASC'
  
  erb :visit
end



