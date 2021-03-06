require 'test_helper'

class PhrasesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @phrase = learnables(:phrase)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:phrases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create phrase" do
    assert_difference('Phrase.count') do
      post :create,
        params:
          { phrase: { lemma: 'ab', phrase: 'ā tertiā hōrā',
            translation: 'von der dritten Stunde an' } }
    end

    assert_redirected_to phrase_path(assigns(:phrase))
  end

  test "should show phrase" do
    get :show, params: { id: @phrase }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @phrase }
    assert_response :success
  end

  test "should update phrase" do
    patch :update,
      params: { id: @phrase, phrase: { translation: 'different translation' } }
    assert_redirected_to phrase_path(assigns(:phrase))
  end

  test "should destroy phrase" do
    assert_difference('Phrase.count', -1) do
      delete :destroy, params: { id: @phrase }
    end

    assert_redirected_to phrases_path
  end
end
