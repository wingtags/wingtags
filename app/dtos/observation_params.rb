class ObservationParams

	def initialize *args
    args[0].each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

	attr_accessor :location
	attr_accessor :latitude
	attr_accessor :longitude
	attr_accessor :observed_at
	attr_accessor :tag_code
	attr_accessor :tag_colour
	attr_accessor :user_id
	attr_accessor :image_url		
end