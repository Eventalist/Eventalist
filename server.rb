require 'bundler/setup'
Bundler.require(:default)

require_relative './lib/connection'
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
    venue = checkEndpoint(event['venue_name'])
    venue_website = checkEndpoint(event['venue_website'])
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
    venue: venue,
    venue_website: venue_website,
    address: street + "\n" + city + "\n" + state + "\n" + postal_code,
    latitude: latitude,
    longitude: longitude,
    price: price,
    link: link
  })
  end
end

def scrapeNycFree()
  page = Nokogiri::HTML(HTTParty.get("http://www.nycgo.com/freeweekly"))

  info = page.css("div.colABoxRight p")
  events = []

  info.each do |item|
    events<<item.text().split("\n\t")
  end

  i=1
  while i<events.length
    Event.create({
      date: events[i][1],
      title: events[i][2],
      address: events[i][3].split("Where: ")[1],
      description: events[i][5],
      category_id: 4,
    })
    i+=1
  end
end

def scrapeNycNightlife()
  html = HTTParty.get("http://clubzone.com/new-york/events/")
  parsed = Nokogiri::HTML(html)

  headline = []

  parsed.css("div.els_info").each do |element|
   headline << {title: element.css("h3 a").text, link: element.css("h3 a").attr("href").text, address: element.css("span a").text, description: element.css("div.els_excerpt p").text, date: element.css("time span").text }
  end

  headline.each do |item|
    Event.create({
      title: item[:title],
      address: item[:address],
      link: item[:link],
      description: item[:description],
      date: item[:date],
      category_id: 5
    })
  end
end


def sendEvents()

  users = User.all

  users.each do |user|

    subscriptions = user.subscriptions

    categories = {}
    email_text = ""
    subscriptions.each do |sub|
      categories[sub.category.name.to_sym] = []
      events = sub.category.events
      events.each do |event|
        categories[sub.category.name.to_sym].push({title: event.title, description: event.description, price: event.price, link: event.link, address: event.address, venue: event.venue, date: event.date})
      end

      categories.each do |category, events|
        email_text += category.to_s + ":\n"
        events.each do |attributes|
          email_text += attributes[:title] + "\n"
          email_text += attributes[:date] + "\n"
          email_text += attributes[:description] + "\n"
          email_text += attributes[:venue] + "\n"
          email_text += attributes[:address] + "\n"
          email_text += attributes[:price] + "\n"
          email_text += attributes[:link] + "\n\n"
        end
      end
    end


    email_info = {
    from: "Eventalist <postmaster@sandbox6a0b16d2c1454109a8dd70bca58d89da.mailgun.org>",
    to: "#{user.name} <#{user.email}>",
    subject: "Today's Eventalist",
    text: "Hi #{user.name},\n\n
    Here are your events: \n\n
    #{email_text} \n\n

    Click here to http://127.0.0.1:9292/subscriptions/#{user.id}"
    }

    url = "https://api.mailgun.net/v2/sandbox6a0b16d2c1454109a8dd70bca58d89da.mailgun.org/messages"
    auth = {:username=>"api", :password=>"key-fc526e192c5951bc94c2e2a8531adaf9"}
    HTTParty.post(url, {body: email_info, basic_auth: auth})
  end

end 
def getEvents()
  pop = HTTParty.get('http://api.nytimes.com/svc/events/v2/listings.json?filters=category:Pop&date_range:2014-10-10&api-key=bd9c3678d4d278b91d84b1082d19d548:15:65256769')
  parseNYTimes(pop, 'music')

  art = HTTParty.get('http://api.nytimes.com/svc/events/v2/listings.json?filters=category:Art&date_range:2014-10-10&api-key=bd9c3678d4d278b91d84b1082d19d548:15:65256769')
  parseNYTimes(art, 'art')

  theater = HTTParty.get('http://api.nytimes.com/svc/events/v2/listings.json?filters=category:Theater&date_range:2014-10-10&api-key=bd9c3678d4d278b91d84b1082d19d548:15:65256769')
  parseNYTimes(theater, 'theater')

  scrapeNycNightlife()

  scrapeNycFree()

end

def newEvents()
  old_events = Event.all()
  if old_events.length == 0
    getEvents()
  elsif Time.now.to_s.split(' ')[0].split('-')[2] > old_events.last.created_at.to_s.split(' ')[0].split('-')[2]
    old_events.delete_all()
    getEvents()
    sendEvents()
  end
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

get("/subscriptions/:id") do 
  binding.pry
  subscriptions = Subscription.where(user_id: params[:id])
  subscriptions.each do |sub|
    sub.destroy()
  end 
  ("You have unsubscribed from Eventalist").to_json
end 


delete("/subscriptions/:email") do

  email = params['email']

binding.pry
end


post("/users") do

  user = User.create(user_params(params))


  user.to_json
end

get ("/users/:id/subscriptions") do

  user = User.find(params["id"])

  subscriptions = user.subscriptions

  categories = []
  subscriptions.each do |sub|
    categories.push(sub.category.name)
  end

  email_info = {
  from: "Eventalist <postmaster@sandbox6a0b16d2c1454109a8dd70bca58d89da.mailgun.org>",
  to: "#{user.name} <#{user.email}>",
  subject: "Thanks for subscribing to Eventalist!",
  text: "Hi #{user.name},\n\n
  You are now subscribed to #{categories.join(" & ")}.\n\n Enjoy using Eventalist! \n\n
  Click here to http://127.0.0.1:9292/subscriptions/#{user.id}"
  }

  url = "https://api.mailgun.net/v2/sandbox6a0b16d2c1454109a8dd70bca58d89da.mailgun.org/messages"
  auth = {:username=>"api", :password=>"key-fc526e192c5951bc94c2e2a8531adaf9"}

  HTTParty.post(url, {body: email_info, basic_auth: auth})


  return ("email has been sent!").to_JSON

end

def subscription_params(params)
  params.slice(*Subscription.column_names)
end

def user_params(params)
  params.slice(*User.column_names)
end
