require 'test_helper'

class VocabulariesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get select" do
    sign_in users(:one)
    get :select, id: vocabularies(:one)
    assert_response :redirect
    assert_equal assigns(:current_user).current_vocabulary, vocabularies(:one)

    get :select, id: vocabularies(:two)
    assert_response :redirect
    assert_equal assigns(:current_user).current_vocabulary, vocabularies(:two)
  end

end
