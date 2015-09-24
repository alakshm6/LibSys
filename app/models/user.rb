class User < ActiveRecord::Base
  has_secure_password
  EMAIL_FORMAT = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
  validates :name, :presence => true, :uniqueness => true, :length => { :in => 2..50 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_FORMAT
  validates :user_type,
  :inclusion  => { :in => [ 'U','A','P' ],
                   :message    => "Members can have user types : U -> Users, A -> Admins, P -> Pre-configured Admin" }
end
