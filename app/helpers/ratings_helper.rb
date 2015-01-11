module RatingsHelper
  def rate_link rating
    link_to rating.to_s, '#', { class: 'btn btn-default rate-link pull-right', 'data-rating' => rating }
  end

  def questions_left_for_today
    current_user.rated_learnables.merge(current_user.learnables).scheduled_for_review.count
  end

  def questions_left_with_bad_rating
    current_user.rated_learnables.merge(current_user.learnables).with_bad_rating.count
  end

  def average_rating
    (current_user.ratings.average('rating') || 0).round(2)
  end

  def next_review
    next_review = current_user.learnables.includes(:ratings).minimum('next_review')

    if next_review
      l next_review.in_time_zone
    else
      'nie'
    end
  end
end
