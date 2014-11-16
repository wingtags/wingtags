class ObservationForm
	include ActiveModel::Model

  attr_accessor :location
  attr_accessor :latitude
  attr_accessor :longitude
  attr_accessor :observed_at
  attr_accessor :tag_code
  attr_accessor :tag_colour
  attr_accessor :user_id
  attr_accessor :user_email
  attr_accessor :has_agreed_to_terms
  attr_accessor :image_url
  attr_reader :observation
  attr_reader :user

  def initialize(params={})
    @tag_colour = TagColours::YELLOW
    super(params)
  end

  def save
    observation = Observation.new(
      :observed_at => @observed_at,
      :latitude => @latitude, 
      :longitude => @longitude,
      :address => @location,
      :image => @image_url,
      :user => get_user,
      :animal => get_animal
    )

    observation.save
  end

  private

  def get_user
    user = nil
    if @user_id
      user = User.find!(@user_id)
    elsif @user_email
      user = User.where(:email.eq @user_email).first!
    else
      user = User.new
    end
    user
  end

  def get_animal
    animal = Animal.where([:tag_code => @tag_code, :tag_colour => TagColours::YELLOW]).first!
  end
end