require 'rethinkdb'
include RethinkDB::Shortcuts

# Remove existing rake task
Rake::Task["db:create"].clear

namespace :db do
  task :create do

    conn = r.connect(:host => ENV['RETHINKDB_HOST'], :port => ENV['RETHINKDB_PORT'])

    # Database

    r.db_create(ENV['RETHINKDB_DB']).run(conn)
    
    
    # Sighting
    
    r.db(ENV['RETHINKDB_DB']).table_create('Sighting', :primary_key => 'SightingID').run(conn)
    r.db(ENV['RETHINKDB_DB']).table('Sighting').index_create('SightingDate').run(conn)
    r.db(ENV['RETHINKDB_DB']).table('Sighting').index_create('SpotterID').run(conn)
    r.db(ENV['RETHINKDB_DB']).table('Sighting').index_create('WildlifeID').run(conn)
    r.db(ENV['RETHINKDB_DB']).table('Sighting').index_create('Geom', {geo: true}).run(conn)
    
    
    # Wildlife
    
    r.db(ENV['RETHINKDB_DB']).table_create('Wildlife', :primary_key => 'WildlifeID').run(conn)
    r.db(ENV['RETHINKDB_DB']).table('Wildlife').index_create('Tag').run(conn)
    
    
    # Spotter
    
    r.db(ENV['RETHINKDB_DB']).table_create('Spotter', :primary_key => 'SpotterID').run(conn)
    r.db(ENV['RETHINKDB_DB']).table('Spotter').index_create('Email').run(conn)
  end
end
  


