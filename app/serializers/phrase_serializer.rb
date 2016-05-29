class PhraseSerializer < ActiveModel::Serializer
  attributes :id
  attribute :phrase, key: :question
  attribute :answer do
    [ object.translation ]
  end
end
