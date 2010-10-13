require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
 
  
  test "user_email_unique" do
    user = User.new(:name =>"cys",
                    :e_mail => "nate.cui@gmail.com",
                    :password =>"123",
                    :password_confirmation =>"123")
    assert !user.save, "e_mail has been taken!"
  end
end
