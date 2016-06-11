class RatingsController < ApplicationController
  MAX_NUMBER_OF_RATINGS_PER_REQUEST = 50

  def index
    number_of_ratings = [ params[:number].to_i, MAX_NUMBER_OF_RATINGS_PER_REQUEST ].min

    ratings =
      current_user
        .rated_learnables
        .for_review
        .limit(number_of_ratings)
        .offset(params[:offset].to_i)

    respond_to do |format|
      format.json { render json: ratings }
    end
  end

  # GET /ratings/review
  # GET /ratings/review.js
  def review
    learnables =
      current_user
        .rated_learnables
        .for_review
        .limit(MAX_NUMBER_OF_RATINGS_PER_REQUEST)

    @status = status
    @learnables_serializer =
      ActiveModel::Serializer::CollectionSerializer.new(learnables, {})
  end

  # PATCH/PUT /ratings/1
  def update
    rating = params[:rating].to_i

    learnable = Learnable.find(params[:id])
    @rating = learnable.rating_for(current_user)

    @rating.recalc_e_factor!(rating)
    @rating.save

    respond_to do |format|
      format.json { render json: status }
    end
  end

  private
  def status
    questions_left_for_today  = current_user.questions_left_for_today
    questions_with_bad_rating = current_user.rated_learnables.with_bad_rating.count

    { "questionsLeftForToday": questions_left_for_today,
      "questionsWithBadRating": questions_with_bad_rating }
  end
end
