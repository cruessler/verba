require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @rating = ratings(:one)
    sign_in users(:one)
  end

  test "should get review" do
    get :review
    assert_response :success
    
    get :review, format: :js
    assert_response :success
  end
  
  test "should rate learnable" do
    get :review
    patch :update, format: :js, id: @rating, rating: 5
    assert_not_nil session[:token]

    patch :update, format: :js, id: @rating, rating: 5, token: session[:token]
    assert_nil session[:token]
    assert_redirected_to review_ratings_path
  end
end
