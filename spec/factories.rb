FactoryGirl.define do

  factory :user do
    #id          '88c0cd22-6b7e-4bfc-9914-2a9fce61d36b'
    first_name  'Normal'
    last_name   'User'
    email       'normal_user@email.com'
    #password    'password'
    #role        'User'
  end

  factory :visitor, class: User do
    # Attributes set according to model defaults
  end

  factory :admin, class: User do
    id          '217826da-1769-438d-ab56-87f7674f87d9'
    first_name  'Admin'
    last_name   'Administrator'
    email       'administrator@email.com'
    password    'password'
    role        'Admin'    
  end

  factory :animal do
    #id          '126'
    name        'cockatoo'     
    gender      'Female'
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
    image           { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'resources', 'images', 'grumpycat.jpg')) }
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
    #id            '021e52d0-a6b0-4f0e-b861-5316de98e1f6'
    observed_at   Time.at(1388534400)
    latitude      52.516667
    longitude     13.383333
    address       'Kottbusser Straße 25, 10999 Berlin'
    note          'I am an important message.'
    image         { File.new(File.join(Rails.root, 'spec', 'resources', 'images', 'grumpycat.jpg')) }
    user
    animal
    # TODO add support for geom property
  end

  factory :sighting, class: Hash do |f|
  end
end