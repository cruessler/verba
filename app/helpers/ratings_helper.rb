module RatingsHelper
  def rate_link rating
    link_to rating.to_s, '#', { class: 'btn btn-default rate-link pull-right', 'data-rating' => rating }
  end
  
  def questions_left_for_today
    current_user.ratings.scheduled_for_review.count
  end
  
  def questions_left_with_bad_rating
    current_user.ratings.with_bad_rating.count
  end
  
  def average_rating
    (current_user.ratings.average('rating') || 0).round(2)
  end
  
  def next_review
    (current_user.ratings.minimum('next_review') || Time.now).in_time_zone
  end
end
