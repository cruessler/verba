class LearnablesController < ApplicationController
  # GET /learnables/overview
  def overview
    @word_count = Word.count
    @phrase_count = Phrase.count
    @questions_for_the_next_24_hours =
        current_user.ratings.where([ "next_review < ?", Time.now + 1.day ]).count
    @questions_for_the_next_48_hours =
        current_user.ratings.where([ "next_review < ?", Time.now + 2.days ]).count
  end
end
