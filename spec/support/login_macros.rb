module LoginMacros
  def login(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Login'
  end

  def logout
    click_link 'Logout'
  end
end
