require 'test_helper'

class WordsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @word = learnables(:word)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:words)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create word" do
    assert_difference('Word.count') do
      post :create,
        params:
          { word: { lemma: 'ădămās', long_lemma: 'ădămās, antis m.',
            translation: 'Stahl' } }
    end

    assert_redirected_to word_path(assigns(:word))
  end

  test "should show word" do
    get :show, params: { id: @word }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @word }
    assert_response :success
  end

  test "should update word" do
    patch :update, params: { id: @word, word: { translation: 'different translation' } }
    assert_redirected_to word_path(assigns(:word))
  end

  test "should destroy word" do
    assert_difference('Word.count', -1) do
      delete :destroy, params: { id: @word }
    end

    assert_redirected_to words_path
  end
end
