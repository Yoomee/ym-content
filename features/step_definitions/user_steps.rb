Given /^I am logged in as an (.*)$/ do |role|
  user = FactoryGirl.create(:user, role.to_sym)
  @current_user = user
  visit sign_in_path
  fill_in "Email", :with => user.email
  fill_in "Password", :with => user.password
  click_button I18n.t(:login)
end

When(/^I go to the dashboard$/) do
  visit content_path
end