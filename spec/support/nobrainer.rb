RSpec.configure do |config|
  config.before(:suite) do
    NoBrainer.update_indexes
  end
 
  config.before(:each) do
    NoBrainer.purge!
  end
end