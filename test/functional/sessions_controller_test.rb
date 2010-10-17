require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  fixtures :users
   # log-in test : if sucessfuly logged in , save the user_id in session 
   test "mlogin" do
     nate = users(:nate)

     get :mlogin, {:e_mail => nate.e_mail, :password => "right"}
     assert_equal nate.id, session[:user_id]    

   end
   
end