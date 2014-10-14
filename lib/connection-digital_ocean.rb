require "active_record"
 
ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	host: '',
	username: 'root',
	database: 'eventalist'
	})

ActiveRecord::Base.logger = Logger.new(STDOUT)