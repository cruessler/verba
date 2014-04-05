class Phrase < Learnable
  validates_presence_of :lemma, :phrase, :translation
  
  def question
    phrase
  end
end
