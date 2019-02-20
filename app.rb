require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
#require 'sqlite3'

set :database, "sqlite3:barbarshop.db"

class Client < ActiveRecord::Base
end

get '/' do
  erb "!!Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a> #{request.path}"
end
