class ObservationForm
	include ActiveModel::Model

  attr_accessor :address
  attr_accessor :tag
  #attr_accessor :location
  attr_accessor :latitude
  attr_accessor :longitude
  #attr_accessor :observed_at
  attr_accessor :timestamp
  #attr_accessor :tag_code
  #attr_accessor :tag_colour
  #attr_accessor :user_id
  #attr_accessor :user_email
  #attr_accessor :has_agreed_to_terms
  attr_accessor :image_url
  attr_accessor :image
  attr_accessor :termscondition
  #attr_reader :observation
  #attr_reader :user
  #attr_accessor :animal

  def to_observation
    params = {
      observed_at: Time.at(@timestamp / 1000),
      latitude: @latitude,
      longitude: @longitude,
      address: @address,
      image: @image,
      animal: Animal.find(@tag)
    }
    puts params
    Observation.new(params)
  end

  #def initialize(params={})
  #  #cast_params(params)
  #  #build_user(params)
  #  #build_animal(params)
  #  #@tag_colour = TagColours::YELLOW
  #  super(params)
  #end

  #def save
  #  observation = Observation.new(
  #    :observed_at => @observed_at,
  #    :latitude => @latitude, 
  #    :longitude => @longitude,
  #    :address => @location,
  #    :image => @image_url,
  #    :animal => @animal
  #  )
#
  #  observation.save
  #  binding.pry
  #  return observation
  #end
#
  #private
#
  #def cast_params(params)
  #  params[:tag_code] = params[:tag_code].to_i
  #  params[:latitude] = params[:latitude].to_f
  #  params[:longitude] = params[:longitude].to_f
  #  params[:observed_at] = Time.at(params[:observed_at])
  #end
#
  #def build_user(params)
  #  if params[:user_id]
  #    params[:user] = User.find!(params[:user_id])
  #  elsif params[:user_email]
  #    params[:user] = User.where(:email.eq params[:user_email]).first!
  #  else
  #    params
  #  end
  #end
#
  #def build_animal(params)
  #  binding.pry
  #  params[:animal] = Animal.where([:tag_code => params[:tag_code]]).first!
  #end
end