require 'test_helper'

class LearnablesControllerTest < ActionController::TestCase
  setup do
    @learnable = learnables(:word)
  end

  test "should get learn" do
    get :learn
    assert_response :success
    
    get :learn, format: :js
    assert_response :success
  end
  
  test "should rate learnable" do
    patch :rate, format: :js, id: @learnable, learnable: { rating: 5 }
    assert_redirected_to learn_learnables_path
  end
end
