require 'rethinkdb'
include NoBrainer
include RethinkDB::Shortcuts

# This script assumes it's being run in the context of the staging
# environment. 

namespace :db do
  task :initialize do
  	raise 'NO!' unless Rails.env.downcase.include?('staging')

  	applicationName = Rails.application.class.parent_name
  	production_db = applicationName
  	staging_db = "#{production_db}Staging"

  	puts ENV['RETHINKDB_HOST']
    puts ENV['RETHINKDB_PORT']
    puts ENV['RETHINKDB_DB']

    NoBrainer.connection
    NoBrainer.drop!
    NoBrainer.sync_indexes

    conn = r.connect(:host => ENV['RETHINKDB_HOST'], :port => ENV['RETHINKDB_PORT'])

    r.db(production_db).tableList().forEach(
    	r.db(staging_db).table(r.row).insert(r.db(production_db).table(r.row))
    )
  end
end