require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test "should get :index" do
    get :index
    assert_response :success
  end
  
  test ":index provides empty @comment" do
    get :index
    assert_not_nil assigns(:comment)
  end
  
  test ":index provides list of @comments" do
    comment = Comment.create(body: "something")
    get :index
    assert assigns(:comments).include?(comment) 
  end
  
  test "successful post to :create answers 302 Created" do
    post_valid_comment
    assert_response :created
  end
  
  test "invalid post to :create answers 424 Unprocessable Entity" do
    post_invalid_comment
    assert_response :unprocessable_entity
  end
  
  test ":create renders index after invalid submission" do
    post_invalid_comment
    assert_template :index
  end
  
  test ":create provides @comments collection after invalid submission" do
    post_invalid_comment
    assert_not_nil assigns(:comments)
  end
  
  test "successful creation redirects to @comment" do
    post_valid_comment
    # assert_redirected_to won't work because of status code 201 Created
    assert @response.header['Location'] =~ /comments\/1/
  end
  
  def post_invalid_comment
    post :create, :comment => { :body => "" }
  end
  
  def post_valid_comment
    post :create, :comment => { :body => "anything suffices" }
  end
end
