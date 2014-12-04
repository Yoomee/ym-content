When(/^I click on the "(.*?)" link$/) do |link|
  click_link link
end

When(/^I visit "(.*?)"$/) do |path|
  visit path
end

Then(/^I should get a (\d+)$/) do |code|
  expect(page.status_code).to eq code.to_i
end
