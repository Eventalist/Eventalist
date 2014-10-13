require 'active_record'

require_relative('./lib/connection-tim')
require_relative('./lib/methods')

Category.create(name: 'music')
Category.create(name: 'art')
Category.create(name: 'theater')
Category.create(name: 'free')
Category.create(name: "nightlife")