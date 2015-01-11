class VocabulariesController < ApplicationController
  def select
    vocabulary = Vocabulary.find(params[:id])

    unless vocabulary.nil?
      current_user.current_vocabulary = vocabulary
      current_user.save
    end

    redirect_to root_url
  end
end
