class Book < ActiveRecord::Base
 #attr_accessor :ISBN, :title, :description, :author, :status

  validates :ISBN, presence: true, length: {is: 13}
  validates :title, presence: true, length: {within: 2..100}
  validates :description, presence: true, length: {within: 2..500}
  validates :author, presence: true, length: {within: 2..200}
  validates :status, presence: true
  validates_uniqueness_of :ISBN
end
