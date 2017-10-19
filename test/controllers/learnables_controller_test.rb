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
end
