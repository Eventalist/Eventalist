require 'active_record'

ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	host: 'localhost',
	username: 'yoshiemuranaka',
	database: 'eventalist'
	})

ActiveRecord::Base.logger = Logger.new(STDOUT)