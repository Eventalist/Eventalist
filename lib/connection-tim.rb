 ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  host: 'localhost',
  username: 'timoorkurdi',
  database: 'eventalist'
  })

ActiveRecord::Base.logger = Logger.new(STDOUT)