class Image
  extend Dragonfly::Model
  include ActiveModel::Model

  dragonfly_accessor :image do
  	storage_options do
  	  { path: "#{SecureRandom.uuid}.jpeg" }
  	end
  end

  attr_accessor :image_uid
  attr_accessor :image_name

  private
end