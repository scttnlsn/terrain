class Example < ActiveRecord::Base
  has_many :widgets
  
  validates :foo, presence: true
end
