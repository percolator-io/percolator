module SessionTestHelper
  def signed_in?(user)
    session[:user_id] == user.id
  end

  def sign_in(user)
    session[:user_id] = user.id
  end
end
