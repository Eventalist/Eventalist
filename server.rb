# require 'bundler/setup'
# Bundler.require(:default)

require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
# require_relative './config/environments'
require_relative './lib/connection-tim'
require_relative './lib/methods'

after do
  ActiveRecord::Base.connection.close
end

before do
  content_type :json
end

get("/events") do
  Event.all.to_json
end

get("/events/:id") do
  Event.find(params[:id]).to_json
end

post("/events") do
  event = Event.create(event_params(params))

  event.to_json
end

put("/events/:id") do
  event = Event.find_by(id: params[:id])
  event.update(event_params(params))

  event.to_json
end

delete("/events/:id") do
  event = Event.find(params[:id])
  event.destroy

  event.to_json
end

def event_params(params)
  params.slice(*Event.column_names)
end
