module VocabulariesHelper
  def current_vocabulary_name
    current_user.current_vocabulary.name
  end

  def current_vocabulary
    if (v = current_user.current_vocabulary)
      "#{v.name} (#{t :word, count: current_word_count}, #{t :phrase, count: current_phrase_count})" 
    else
      'kein Wortschatz ausgewählt'
    end
  end
end
