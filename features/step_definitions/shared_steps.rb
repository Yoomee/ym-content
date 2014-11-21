When(/^I click on the "(.*?)" link$/) do |link|
  click_link link
end

When(/^I visit "(.*?)"$/) do |path|
  visit path
end
