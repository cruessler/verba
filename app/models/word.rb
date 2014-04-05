class Word < Learnable
  validates_presence_of :lemma, :long_lemma, :translation
  
  def question
    lemma
  end
end
