class Vocabulary < ActiveRecord::Base
  has_and_belongs_to_many :learnables
end
