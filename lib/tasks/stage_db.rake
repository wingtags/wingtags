require 'rethinkdb'
include NoBrainer
include RethinkDB::Shortcuts

# This script assumes it's being run in the context of the staging
# environment. 

namespace :db do
  task :stage => :environment do
    staging_db = ENV['RETHINKDB_DB']
    production_db = Rails.application.class.parent_name

  	raise 'The db:stage task can only be run in the staging environment.' unless Rails.env.downcase.include?('staging')
    raise "You are trying to run the db:staging task on the database #{staging_db}, which does not have 'Staging' in its name. Aborting to avoid unintended data loss." unless staging_db.downcase.include?('staging')

    NoBrainer.drop!
    NoBrainer.sync_indexes
    NoBrainer.run { |r| r.db(production_db).table_list().for_each { |table_name|
      r.db(staging_db).table(table_name).insert(r.db(production_db).table(table_name))
    }}
  end
end