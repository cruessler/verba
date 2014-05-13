class RatingsController < ApplicationController
  before_action :set_rating, only: [ :update ]
  
  # GET /ratings/review
  # GET /ratings/review.js
  def review
    @learnable = current_user.rated_learnables.next_for_review
    @rating = @learnable.rating_for(current_user) if @learnable
    @token = session[:token] = SecureRandom.urlsafe_base64(16)
  end
  
  # PATCH/PUT /ratings/1
  def update
    if session[:token] == params[:token]
      session[:token] = nil
      rating = params[:rating].to_i

      if @rating.user == current_user
        @rating.recalc_e_factor!(rating)
        @rating.save
      end
    end

    redirect_to action: 'review'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end
end
