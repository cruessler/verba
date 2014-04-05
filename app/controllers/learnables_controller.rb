class LearnablesController < ApplicationController
  before_action :set_learnable, only: [ :rate ]
  
  # GET /learnables/overview
  def overview
    @word_count = Word.count
    @phrase_count = Phrase.count
    @questions_for_the_next_24_hours =
        Learnable.where([ "next_review < ?", Time.now + 1.day ]).count
    @questions_for_the_next_48_hours =
        Learnable.where([ "next_review < ?", Time.now + 2.days ]).count
  end
  
  # GET /learnables/learn
  # GET /learnables/learn.js
  def learn
    @learnable = Learnable.next_for_review
  end
  
  # PATCH /learnables/rate
  def rate
    rating = params[:rating].to_i
    @learnable.recalc_e_factor!(rating)
    @learnable.save

    redirect_to action: 'learn'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_learnable
      @learnable = Learnable.find(params[:id])
    end
end
