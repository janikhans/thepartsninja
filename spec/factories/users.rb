FactoryGirl.define do
  factory :user do
    username        'TestUser'
    email           'test@example.com'
    password        'password'
    password_confirmation 'password'
    role            'user'
  end

  factory :admin do
    username        'TestAdmin'
    email           'test@example.com'
    password        'password'
    password_confirmation 'password'
    role            'admin'
  end
end