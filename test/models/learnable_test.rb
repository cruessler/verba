require 'test_helper'

class LearnableTest < ActiveSupport::TestCase
  test "can be flagged" do
    word = learnables(:word)

    refute word.is_flagged

    word.flag

    assert word.is_flagged
  end
end
