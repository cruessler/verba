require 'test_helper'

class VocabularyTest < ActiveSupport::TestCase
  test "should import a file containing words and phrases" do
    test_file = File.new File.expand_path('test/fixtures/words/test_import.de.words')

    imported_items = Vocabulary.import test_file
    assert_equal 3, imported_items

    vocabulary = Vocabulary.find_by name: 'Lateinische Vokabeln'

    assert_not_nil vocabulary
    assert_equal 3, vocabulary.learnables.count
    assert_equal 1, vocabulary.words.count
    assert_equal 'ad', vocabulary.words.first.lemma
    assert_equal 2, vocabulary.phrases.count
    assert_equal 'ad urbem venīre', vocabulary.phrases.last.phrase
  end
end
