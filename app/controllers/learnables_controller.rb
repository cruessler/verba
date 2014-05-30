class LearnablesController < ApplicationController
  # GET /learnables/overview
  def overview
    @questions_for_now = current_user.questions_for_the_next 0
    @questions_for_the_next_24_hours = current_user.questions_for_the_next 1.day
    @questions_for_the_next_48_hours = current_user.questions_for_the_next 2.days
  end
end
