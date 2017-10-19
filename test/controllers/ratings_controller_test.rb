require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @rating = ratings(:one)
    @user = users(:one)

    sign_in @user
  end

  test "should get review" do
    get :review
    assert_response :success
  end

  test "should get review if no question is left" do
    Rating.all.each do |r|
      r.next_review = Time.now + 1.day
      r.rating = 5
      r.save
    end

    get :review
    assert_response :success
    assert_select 'div#question'
  end

  test "should rate learnable" do
    get :review
    patch :update, params: { format: :json, id: @rating.learnable, rating: 5 }
    assert_response :success
  end
end
