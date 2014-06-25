# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

DEFAULT_USERS   = [
  {
    :first_name => 'Rich',
    :last_name  => 'Wells',
    :email      => 'rich@yoomee.com',
    :role       => 'admin'
  },
  {
    :first_name => 'David',
    :last_name  => 'Thompson',
    :email      => 'david@yoomee.com',
    :role       => 'admin'
  },
  {
    :first_name => 'Matt',
    :last_name  => 'Atkins',
    :email      => 'matt@yoomee.com',
    :role       => 'admin'
  },
  {
    :first_name => 'Andy',
    :last_name  => 'Mayer',
    :email      => 'andy@yoomee.com',
    :role       => 'admin'
  },
  {
    :first_name => 'Nicola',
    :last_name  => 'Mayer',
    :email      => 'nicola@yoomee.com',
    :role       => 'admin'
  },
  {
    :first_name => 'Edward',
    :last_name  => 'Andrews-Hodgson',
    :email      => 'edward@yoomee.com',
    :role       => 'admin'
  },
  {
    :first_name => 'Jon',
    :last_name  => 'Kyte',
    :email      => 'jon@yoomee.com',
    :role       => 'admin'
  },
  {
    :first_name => 'Tim',
    :last_name  => 'Brazier',
    :email      => 'tim@yoomee.com',
    :role       => 'admin'
  },
  {
    :first_name => 'Carrie',
    :last_name  => 'Jackson',
    :email      => 'carrie@yoomee.com',
    :role       => 'admin'
  },
  {
    :first_name => 'Greg',
    :last_name  => 'Woodcock',
    :email      => 'greg@yoomee.com',
    :role       => 'admin'
  }
]

if (User.count == 0)
  DEFAULT_USERS.each do |user_attrs|
    user = User.new(user_attrs)
    user.encrypted_password = "$2a$10$e5A0deaeILATXz27sj/Sn.2p.YheKLyrSvIG9ksP41PMaqLH3cNfe"
    user.save(:validate => false)
  end
end

# project seed data
# case Rails.env
#   when "development"
# end
