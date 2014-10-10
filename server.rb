# require 'bundler/setup'
# Bundler.require(:default)

require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'httparty'
# require_relative './config/environments'
require_relative './lib/connection-tim'
# require_relative './lib/connection-eric'
require_relative './lib/methods'

after do
  ActiveRecord::Base.connection.close
end

before do
  content_type :json
end

get("/") do
  content_type :html
  html = File.read('./views/index.html')
end

get("/events") do
  Event.all.to_json
end

post("/subscriptions") do
  subscription = Subscription.create(subscription_params(params))

  subscription.to_json
end

def subscription_params(params)
  params.slice(*Subscription.column_names)
end
