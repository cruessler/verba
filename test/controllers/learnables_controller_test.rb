require 'test_helper'

class LearnablesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  test "should get overview" do
    get :overview
    assert_redirected_to new_user_session_path
    
    sign_in users(:one)
    get :overview
    assert_response :success

    assert_select '#dropdown-vocabularies', Regexp.new(assigns(:current_user).current_vocabulary.try(:name))
  end

  test "should flag learnable" do
    phrase = learnables(:phrase)
    sign_in users(:one)

    refute phrase.is_flagged

    patch :flag, params: { format: :json, id: phrase }

    json = JSON.parse @response.body

    assert_response :success
    assert json["is_flagged"]
  end
end
