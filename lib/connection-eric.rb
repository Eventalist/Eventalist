require "active_record"
 
ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	host: 'localhost',
	username: 'eric',
	database: 'eventalist'
	})

ActiveRecord::Base.logger = Logger.new(STDOUT)