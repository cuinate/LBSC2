class Place < ActiveRecord::Base
  has_many :questions
  has_many :activities
end
