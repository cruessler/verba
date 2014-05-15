require 'test_helper'

class LearnablesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get overview" do
    get :overview
    assert_redirected_to new_user_session_path
    
    sign_in users(:one)
    get :overview
    assert_response :success
  end
end
