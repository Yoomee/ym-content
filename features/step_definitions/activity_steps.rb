Then(/^I should see the (\d+) activity items$/) do |n|
  page.all("ul.cms-activities li").count.should eql(n.to_i)
end

When(/^I choose to see older activity$/) do
  click_link "See older activity"
  Timeout.timeout(Capybara.default_wait_time) do
    loop until page.evaluate_script('jQuery.active').zero?
  end
end

Then(/^I should see the "(.*?)" activity$/) do |action|
  expect(page).to have_content("#{@content_package.name} was #{action} by #{@current_user.full_name}")
end
