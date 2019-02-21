require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
#require 'sqlite3'

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
  erb 'Hi!'
end

get '/admin' do
  @barbers = Barber.order 'name ASC'
  @visits = Visit.all
  
  erb :admin
end

post '/admin' do
  # TODO как оставить значения полей
  
  @visits = Visit.all
  
  b = Barber.new params[:barber]
  if b.invalid?
    @error = b.errors.full_messages.join ', '
    return erb :admin
  end
  b.save
    
  erb :admin
end

get '/visit' do
  @barber_id = 0
  @barbers = Barber.order 'name ASC'
  
  erb :visit
end

post '/visit' do
  #~ @barber_id = params[:barber_id]
  #~ @client_name = params[:client_name]
  #~ @client_phone = params[:client_phone]
  #~ @date_time = params[:date_time]
  #~ @colorpicker = params[:colorpicker]
  
  #~ h_invalid = {
    #~ :client_name => 'Enter your name',
    #~ :client_phone => 'Enter your pone',
    #~ :date_time => 'Enter date - time'
    #~ }
  #~ @error = h_invalid.select{|k,v| params[k].strip == ''}.values.join ', '
  #~ unless @error == ''
  #~ @error += @barber_id.to_s
    #~ @barbers = Barber.order 'name ASC'
    #~ return erb :visit
  #~ end
  
  #~ client = Client.find_or_initialize_by :phone => @client_phone 
  #~ if client.persisted? && client.name != @client_name  
    #~ @error = "This phone number: #{@client_phone} belongs another user"
    #~ @barbers = Barber.order 'name ASC'
    #~ return erb :visit
  #~ end
  
  #~ if client.new_record?
    #~ client.name = @client_name
    #~ client.phone = @client_phone
    #~ client.save
  #~ end 
  
  client = Client.find_by :phone => params[:client][:phone]
  if client && client.name != params[:client][:name]  
    @error = "This phone number: #{params[:client][:phone]} belongs another user"
    #@barbers = Barber.order 'name ASC'
    return erb :visit
  end 
  
  unless client
    client = Client.new params[:client]
    if client.invalid?
      @error = client.errors.full_messages.join ', '
      return erb :visit
    end
    client.save
  end
  
  params[:visit][:client_id] = client.id
  visit = Visit.new params[:visit]
  if client.invalid?
    @error = client.errors.full_messages.join ', '
    return erb :visit
  end
  visit.save
                        
  barber = Barber.find params[:visit][:barber_id]
  
  @message = "Dear #{client.name} we'll waiting for you at #{@date_time} to barber #{barber.name}. You may contact phone: #{barber.phone}"
  #~ @barbers = Barber.order 'name ASC'
  
  #~ @barber_id = 0
  #~ @client_name = ''
  #~ @client_phone = ''
  #~ @date_time = ''
  #~ @colorpicker = ''
  
  erb :visit
end

