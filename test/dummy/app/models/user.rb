class User < ActiveRecord::Base
  
  include YmUsers::User

  validates_presence_of :first_name, :last_name
  validates :email, :email => true, :presence => true, :uniqueness => true
  validates_presence_of :password, :on => :create
  
end