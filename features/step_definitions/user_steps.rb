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

Given(/^there are (\d+) users$/) do |n|
  if n.to_i.zero?
    User.where('id != ?', @current_user.id).destroy_all
  end
  @users = [].tap do |arr|
    n.to_i.times do
      arr << FactoryGirl.create(:user, role: 'author')
    end
  end
  @user = @users.first
end

When(/^I fill in the new cms user form and submit$/) do
  visit new_cms_user_path
  @user = FactoryGirl.build(:user, role: 'author')
  fill_in "cms_user_first_name", :with => @user.first_name
  fill_in "cms_user_last_name", :with => @user.last_name
  fill_in "cms_user_email", :with => @user.email
  fill_in "cms_user_password", :with => @user.password
  select(@user.role, :from => 'cms_user_role')
  click_button('Save')
end

Then(/^the user is (created|updated)$/) do |action|
  visit cms_users_path(@user)
  expect(page).to have_content(@user.first_name)
  expect(page).to have_content(@user.last_name)
  if action == 'updated'
    expect(page).to have_content("Edited")
  end
  expect(page).to have_content(@user.role)
end

When(/^I fill in the edit cms user form and submit$/) do
  visit edit_cms_user_path(@user)
  fill_in "cms_user_last_name", :with => "Edited"
  select(@user.role, :from => 'cms_user_role')
  click_button('Save')
  @user = User.find(@user.id)
end

When(/^I visit the cms user index$/) do
  visit cms_users_path
  expect(page).to have_content("ADD NEW USER")
end

Then(/^I see the cms users$/) do
  page.has_table? "users-table"
  user_rows = page.all('.user-row')
  user_rows.count.should > 1
end

When(/^I set the user as inactive$/) do
  btn = page.find(".user-row[data_user-id='#{@user.id}']").find('.user-actions').find('.set-active-btn')
  expect(btn).not_to be_nil
  btn.click
  sleep(2)
end

Then(/^the user is inactive$/) do
  @user = User.find(@user.id)
  expect(@user.active).to be_falsey
end


