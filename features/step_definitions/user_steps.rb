Given /^I am logged in$/ do
  user = FactoryGirl.create(:user)
  visit path_to('/login')
  fill_in "Email", :with => user.email
  fill_in "Password", :with => user.password
  click_button I18n.t(:login)
end
