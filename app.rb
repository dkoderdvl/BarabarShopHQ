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

get '/' do
  
  @barbers = Barber.order 'phone DESC'
  
  erb :barbers
  
end
