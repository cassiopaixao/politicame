require 'test_helper'

class ProposicaoControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get register_vote" do
    get :register_vote
    assert_response :success
  end

end
