require "active_record"

class User < ActiveRecord::Base
	self.has_many(:subscriptions)
end

class Event < ActiveRecord::Base
	self.has_one :category
end

class Subscription < ActiveRecord::Base
	self.belongs_to :user
	self.belongs_to :category
end

class Category < ActiveRecord::Base
		self.has_many(:events)
end
