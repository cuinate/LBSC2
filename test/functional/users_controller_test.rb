require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  fixtures :users
  # log-in test : if sucessfuly logged in , save the user_id in session 
  test "login" do
    nate = users(:nate)
    
    get :log_in, {:e_mail => nate.e_mail, :password => "right"}
    assert_equal nate.id, session[:user_id]    
    
  end
  
  test "wrong password" do
    nate = users(:nate)
    get :log_in, {:e_mail => nate.e_mail, :password => "wrong"}
    assert_equal "password wrong, please try again!", flash[:notice]
    
  end
  
  test "wrong account" do 
    get :log_in, {:e_mail => "xxx@sin.com", :password => "wrong"}
    assert_equal "user does not exist!", flash[:notice]
  end
  
end
