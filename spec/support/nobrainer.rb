require 'rake'

RSpec.configure do |config|
  config.before(:suite) do
  	NoBrainer.drop!
  	NoBrainer.sync_indexes
  end
 
  config.before(:each) do
    NoBrainer.purge!
  end
end