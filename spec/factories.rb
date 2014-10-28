FactoryGirl.define do  factory :observation do
    
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
end