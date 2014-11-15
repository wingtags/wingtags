FactoryGirl.define do

  factory :observation do
    
  end


  factory :user do
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
    name        'cockatoo'     
    gender      'female'
    tag_code    '209'
    tag_colour  'Yellow'
    notes       'She is feisty.'
  end

  factory :valid_observation, class: ObservationForm do
    location      'Kottbusser Straße 25, 10999 Berlin'
    latitude      52.516667
    longitude     13.383333
    observed_at   1388534400  # 2014-01-01T00:00:00Z
    tag_code      22
    tag_colour    'Yellow'
    user_id       'a95f30b4-a518-4e5b-b40e-36553146f2ec'
    user_email    'abc@email.com'
    image_url     'c8a55008-370e-4923-b3c8-cef6e325ccc1'
  end
end