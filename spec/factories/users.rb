# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name             'John'
    last_name              'Doe'
    email                  'c@talin.ro'
    password               '123qwe123'
    password_confirmation  '123qwe123'
  end
end
