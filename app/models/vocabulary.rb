class Vocabulary < ActiveRecord::Base
  has_and_belongs_to_many :learnables
  has_and_belongs_to_many :words, join_table: 'learnables_vocabularies', association_foreign_key: 'learnable_id'
  has_and_belongs_to_many :phrases, join_table: 'learnables_vocabularies', association_foreign_key: 'learnable_id'

  def self.import file
    first_line = file.readline
    vocabulary_name = 'Neuer Wortschatz'

    if match = first_line.match(/# vocabulary: (.*)/)
      vocabulary_name = match[1]
    else
      file.rewind
    end

    vocabulary = Vocabulary.find_or_create_by name: vocabulary_name

    lemma = ''
    imported_items = 0

    Learnable.transaction do
      item_count_before = vocabulary.learnables.count

      file.each do |line|
        next if line[0] == '#'

        columns = line.split "\t"
        lemma = columns[0] unless columns[0].empty?

        next unless columns.length == 3

        if columns[0].empty?
          learnable =
            Phrase.find_or_create_by(lemma: lemma, phrase: columns[1], translation: columns[2])
        else
          learnable =
            Word.find_or_create_by(lemma: lemma, long_lemma: columns[1], translation: columns[2])
        end

        learnable.vocabularies << vocabulary unless learnable.vocabularies.exists?(vocabulary.id)
      end

      imported_items = vocabulary.learnables.count - item_count_before
    end

    imported_items
  end
end
