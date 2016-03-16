module LoginHelper
  def do_login(username, password)
   	visit login_path
   	fill_in "Name",							with: username
		fill_in "Password",					with:	password 
		click_button 'Log in'
   end
end