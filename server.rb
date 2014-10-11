# require 'bundler/setup'
# Bundler.require(:default)

require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'httparty'
# require_relative './config/environments'
# require_relative './lib/connection-yoshie'
# require_relative './lib/connection-tim'
require_relative './lib/connection-eric'
require_relative './lib/methods'

after do
  ActiveRecord::Base.connection.close
end


before do
  content_type :json
end

def checkEndpoint(endpoint)
  endpoint ? endpoint : ""
end

def parseNYTimes(events, cat)
  if cat == 'music'
    cat_id = 1
  elsif cat == 'art'
    cat_id = 2
  elsif cat == 'theater'
    cat_id = 3
  end

  events['results'].each do |event|
    title = checkEndpoint(event['event_name'])
    description = checkEndpoint(event['web_description'])    
    date = checkEndpoint(event['date_time_description'])
    street = checkEndpoint(event['street_address'])
    city = checkEndpoint(event['city'])
    state = checkEndpoint(event['state'])
    postal_code = checkEndpoint(event['postal_code'])
    latitude = checkEndpoint(event['geocode_latitude'])
    longitude = checkEndpoint(event['geocode_longitude'])
    price = checkEndpoint(event['price'])
    link = checkEndpoint(event['event_detail_url'])

    Event.create({
    category_id: cat_id,
    title: title,
    description: description,  
    date: date,
    address: street + "\n" + city + "\n" + state + "\n" + postal_code,
    latitude: latitude,
    longitude: longitude,
    price: price,
    link: link
  })
  end
end

def newEvents()
  old_events = Event.all()
  old_events.delete_all()

  pop = HTTParty.get('http://api.nytimes.com/svc/events/v2/listings.json?filters=category:Pop&date_range:2014-10-10&api-key=bd9c3678d4d278b91d84b1082d19d548:15:65256769')
  parseNYTimes(pop, 'music')

  art = HTTParty.get('http://api.nytimes.com/svc/events/v2/listings.json?filters=category:Art&date_range:2014-10-10&api-key=bd9c3678d4d278b91d84b1082d19d548:15:65256769')
  parseNYTimes(art, 'art')

  theater = HTTParty.get('http://api.nytimes.com/svc/events/v2/listings.json?filters=category:Theater&date_range:2014-10-10&api-key=bd9c3678d4d278b91d84b1082d19d548:15:65256769')
  parseNYTimes(theater, 'theater')
end

newEvents()

get("/") do

  content_type :html
  
  File.read('./views/index.html')

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
