require "active record"

class User < ActiveRecord::Base
	self.has_many(:subscriptions)
	self.has_many(:events)
end 

class Event < ActiveRecord::Base
end

class Subscription < ActiveRecord::Base
end 

class Category <ActiveRecord::Base
		self.has_many(:events)
		self.has_many(:subscriptions)
end 