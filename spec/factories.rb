FactoryGirl.define do

  factory :user do
    id          '88c0cd22-6b7e-4bfc-9914-2a9fce61d36b'
    first_name  'Normal'
    last_name   'User'
    email       'normal_user@email.com'
    password    'password'
    role        'User'
  end

  factory :visitor, class: User do
    # Attributes set according to model defaults
  end

  factory :admin, class: User do
    first_name  'Admin'
    last_name   'Administrator'
    email       'administrator@email.com'
    password    'password'
    role        'Admin'    
  end

  factory :animal do
    id          '126'
    name        'cockatoo'     
    gender      'female'
    tag_code    209
    #tag_colour  'Yellow'
    notes       'She is feisty.'
  end

  factory :observation_form do
    tag             209
    address         'Kottbusser Straße 25, 10999 Berlin'
    latitude        52.516667
    longitude       13.383333
    timestamp       1388534400000  # 2014-01-01T00:00:00Z
    termscondition  true
    user_id         '88c0cd22-6b7e-4bfc-9914-2a9fce61d36b'
    #image           { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'assets', 'images', 'grumpycat.jpg')) }
  end

  #factory :observation, class: ObservationForm do
  #  tag_code      209
  #  location      'Kottbusser Straße 25, 10999 Berlin'
  #  latitude      52.516667
  #  longitude     13.383333
  #  observed_at   Time.at(1388534400)  # 2014-01-01T00:00:00Z
  #  image_url     'c8a55008-370e-4923-b3c8-cef6e325ccc1'
  #end

  factory :observation do
    user
    animal
    observed_at   Time.at(1388534400)
    latitude      52.516667
    longitude     13.383333
    address       'Kottbusser Straße 25, 10999 Berlin'
    image         'c8a55008-370e-4923-b3c8-cef6e325ccc1'
    # TODO add support for geom property
  end

  factory :sighting, class: Hash do |f|
  end
end