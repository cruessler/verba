class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :ratings, dependent: :destroy do
    def random_next
      order('RANDOM()').first
    end
    
    def with_bad_rating
      where('rating < 4')
    end
    
    def next_with_bad_rating
      with_bad_rating.random_next
    end
    
    def scheduled_for_review
      where([ "rating >= 4 AND next_review < ?", Time.now ])
    end
    
    def next_scheduled_for_review
      scheduled_for_review.random_next
    end
    
    def next_not_yet_rated
      not_yet_rated = proxy_association.owner.learnables.not_yet_rated.first
      
      if not_yet_rated
        Rating.create(learnable: not_yet_rated, user: proxy_association.owner)
      end
    end
    
    def next_for_review
      next_not_yet_rated || next_scheduled_for_review || next_with_bad_rating
    end
  end
  
  has_many :learnables, through: :ratings do
    def not_yet_rated
      Learnable.joins("LEFT JOIN ratings ON ratings.learnable_id = learnables.id AND ratings.user_id = #{proxy_association.owner.id }").
        where('ratings.user_id IS NULL')
    end
  end
end
