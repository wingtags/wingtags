require 'rethinkdb'
include NoBrainer
include RethinkDB::Shortcuts

# This script assumes it's being run in the context of the staging
# environment. 

namespace :db do
  task :initialize do
    raise 'NO!' unless Rails.env.downcase.include?('staging')

    NoBrainer.drop!
    NoBrainer.sync_indexes

    conn = r.connect(:host => ENV['RETHINKDB_HOST'], :port => ENV['RETHINKDB_PORT'])

    r.db('my_db').tableList().foreach(r.db('my_db_cloned').tableCreate(r.row))
    r.db('my_db').tableList().forEach(r.db('my_db_cloned').table(r.row).insert(r.db('my_db').table(r.row)))
  end
end