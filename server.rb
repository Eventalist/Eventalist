# require 'bundler/setup'
# Bundler.require(:default)

require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'httparty'
# require_relative './config/environments'
<<<<<<< HEAD
require_relative './lib/connection-yoshie'
=======
# require_relative './lib/connection-tim'
require_relative './lib/connection-eric'
>>>>>>> 7d10fcdffc2a00359ca3cf156e96df2004026097
require_relative './lib/methods'

after do
  ActiveRecord::Base.connection.close
end

before do
  content_type :json
end

get("/") do
<<<<<<< HEAD

  content_type :html
  
  File.read('./views/index.html')

=======
  content_type :html
  html = File.read('./views/index.html')
>>>>>>> 7d10fcdffc2a00359ca3cf156e96df2004026097
end

get("/events") do
  Event.all.to_json
end

post("/subscriptions") do
 
  subscription = Subscription.create(subscription_params(params))

  subscription.to_json

end

# def subscription_params(params)
#   params.slice(*Subscription.column_names)
# end
