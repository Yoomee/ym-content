Given(/^there are (\d+) content types$/) do |n|
  @content_types = [].tap do |arr|
    n.to_i.times do
      arr << FactoryGirl.create(:content_type)
    end
  end
  @content_type = @content_types.first
end

When(/^I go to the list of content types$/) do
  visit path_to('/content_types')
end

Then(/^I see the content types$/) do
  @content_types.each do |content_type|
    expect(page).to have_content(content_type.to_s)
  end
end
