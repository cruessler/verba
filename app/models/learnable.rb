class Learnable < ActiveRecord::Base
  has_and_belongs_to_many :vocabularies
  has_many :ratings
  
  def rating_for(current_user)
    ratings.find_or_create_by(user: current_user)
  end
end
