class Learnable < ActiveRecord::Base
  has_and_belongs_to_many :vocabularies
  has_many :ratings
  
  def rating_for(user)
    ratings.find_or_create_by(user: user)
  end

  def flag
    self.is_flagged = true
  end
end
