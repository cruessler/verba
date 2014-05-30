module LearnablesHelper
  def current_word_count
    current_user.learnables.where([ 'type = ?', 'Word' ]).count || 0
  end
  
  def current_phrase_count
    current_user.learnables.where([ 'type = ?', 'Phrase' ]).count || 0
  end
end
