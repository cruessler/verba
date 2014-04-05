module LearnablesHelper
  def rate_link rating
    link_to rating.to_s, '#', { class: 'btn btn-default rate-link pull-right', 'data-rating' => rating }
  end
  
  def questions_left_for_today
    Learnable.scheduled_for_review.count
  end
  
  def questions_left_with_bad_rating
    Learnable.with_bad_rating.count
  end
  
  def average_rating
    Learnable.average('rating').round(2)
  end
  
  def next_review
    Learnable.minimum('next_review').in_time_zone
  end
end
