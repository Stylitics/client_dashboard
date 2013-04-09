# encoding: utf-8

namespace :user do

  desc 'Create first user'
  task :create_first => ['environment'] do
    user = User.new(
      first_name:             'Cătălin',
      last_name:              'Ilinca',
      email:                  'c@talin.ro',
      password:               '123qwe123',
      password_confirmation:  '123qwe123'
    )
    puts "First user created: #{user.name}." if user.save
  end

end
