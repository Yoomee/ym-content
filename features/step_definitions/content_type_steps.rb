Given(/^there (is|are) (\d+) content types?$/) do |ia,n|
  if n.to_i.zero?
    ContentType.destroy_all
  end
  @content_types = [].tap do |arr|
    n.to_i.times do
      arr << FactoryGirl.create(:content_type)
    end
  end
  @content_type = @content_types.first
end

When(/^I go to the list of content types$/) do
  visit content_types_path
end

Then(/^I see the content types$/) do
  @content_types.each do |content_type|
    expect(page).to have_content(content_type.to_s)
  end
end

When(/^I fill in the new content type form and submit$/) do
  visit new_content_type_path
  @content_type = FactoryGirl.build(:content_type)
  fill_in('content_type_name', :with => @content_type.name)
  @content_type.content_attributes.each_with_index do |content_attribute, idx|
    click_link('add content_attribute')
    all(".nested-fields input[id$='_slug']")[idx].set(content_attribute.slug)
    all(".nested-fields input[id$='_name']")[idx].set(content_attribute.name)
    all(".nested-fields textarea[id$='_description']")[idx].set(content_attribute.description)
    all(".nested-fields input[id$='_field_type']")[idx].set(content_attribute.field_type)
  end
  click_button('Create Content type')
end

Then(/^the content type is created$/) do
  visit content_types_path
  expect(page).to have_content(@content_type.to_s)
end