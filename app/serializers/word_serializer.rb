class WordSerializer < ActiveModel::Serializer
  attributes :id
  attribute :lemma, key: :question
  attribute :answer do
    [ object.long_lemma, object.translation ]
  end
  attribute :is_flagged
end
