class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :current_vocabulary, class_name: 'Vocabulary'
  has_many :ratings, dependent: :destroy

  has_and_belongs_to_many :rated_learnables, class_name: 'Learnable', join_table: 'ratings' do
    def in_current_vocabulary
      merge(proxy_association.owner.learnables)
    end

    def with_bad_rating
      where('rating < 4')
    end

    def scheduled_for_review
      where([ "rating >= 4 AND next_review < ?", Time.now ])
    end

    def not_yet_rated
      proxy_association.owner.learnables.not_yet_rated
    end

    def for_review
      Learnable
        .from(
          "(#{not_yet_rated.to_sql}) AS learnables " +
          "UNION (SELECT * FROM (#{in_current_vocabulary.scheduled_for_review.order("RANDOM()").to_sql}) AS for_review) " +
          "UNION (SELECT * FROM (#{in_current_vocabulary.with_bad_rating.order("RANDOM()").to_sql}) AS with_bad_rating)")
        .select("*")
    end
  end

  has_many :learnables, through: :current_vocabulary do
    def not_yet_rated
      Learnable.joins("LEFT JOIN ratings ON ratings.learnable_id = learnables.id AND ratings.user_id = #{proxy_association.owner.id }").
        where('ratings.user_id IS NULL')
    end
  end

  after_initialize :set_default_values

  def set_default_values
    self.current_vocabulary = Vocabulary.first if current_vocabulary.nil?
  end

  def reset_ratings!
    ratings.delete_all
  end

  def questions_for_the_next timespan
    rated_learnables.where([ 'next_review < ?', Time.now + timespan ]).count
  end

  def questions_left_for_today
    learnables.not_yet_rated.count +
      rated_learnables.merge(learnables).scheduled_for_review.count
  end
end
