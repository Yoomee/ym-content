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

Then(/^I see the content types$/) do
  click_link "Content types"
  @content_types.each do |content_type|
    expect(page).to have_content(content_type.to_s)
  end
end

When(/^I fill in the new content type form and submit$/) do
  visit new_content_type_path
  @content_type = FactoryGirl.build(:content_type)
  fill_in('content_type_name', :with => @content_type.name)
  @content_type.content_attributes.each_with_index do |content_attribute, idx|
    click_link('Add content attribute') unless idx.zero?
    all(".nested-fields input[id$='_name']")[idx].set(content_attribute.name)
    all(".nested-fields textarea[id$='_description']")[idx].set(content_attribute.description)
    Capybara.ignore_hidden_elements = false
    all(".nested-fields select[id$='_field_type']")[idx].find("option[value='#{content_attribute.field_type}']").select_option
    Capybara.ignore_hidden_elements = true
  end
  click_button('Create Content type')
end

Then(/^the content type is created$/) do
  step "I go to the sitemap"
  click_link "Content types"
  expect(page).to have_content(@content_type.to_s)
end

When(/^I update the content type$/) do
  visit edit_content_type_path(@content_type)
  fill_in('content_type_name', :with => 'Modified name')
  click_button("Update Content type")
end

Then(/^the content type should change$/) do
  visit edit_content_type_path(@content_type)
  expect(find_field('content_type[name]').value).to eq('Modified name')
end

When(/^I duplicate the content type$/) do
  visit duplicate_content_type_path(@content_type)
end

Then(/^I see a new content type with all the same attributes$/) do
  @content_type.content_attributes.each_with_index do |content_attribute, idx|
    ContentAttribute.fields_to_duplicate.each do |attribute|
      expected_value = content_attribute.send(attribute)
      if expected_value.is_a?(TrueClass) || expected_value.is_a?(FalseClass)
        if expected_value
          expect(find_field("content_type[content_attributes_attributes][#{idx}][#{attribute}]")).to be_checked
        else
          expect(find_field("content_type[content_attributes_attributes][#{idx}][#{attribute}]")).to_not be_checked
        end
      elsif expected_value.to_s.present?
        expect(find_field("content_type[content_attributes_attributes][#{idx}][#{attribute}]").value.to_s).to eq(expected_value.to_s)
      end
    end
  end
end

When(/^I duplicate the first content type onto the second$/) do
  visit duplicate_content_type_path(@content_types.first, :to => @content_types.last)
end

Then(/^I see a second content type with all the attributes of the first$/) do
  seed = @content_types.first
  target = @content_types.last
  (target.content_attributes + seed.content_attributes).each_with_index do |content_attribute, idx|
    ContentAttribute.fields_to_duplicate.each do |attribute|
      expected_value = content_attribute.send(attribute)
      if expected_value.is_a?(TrueClass) || expected_value.is_a?(FalseClass)
        if expected_value
          expect(find_field("content_type[content_attributes_attributes][#{idx}][#{attribute}]")).to be_checked
        else
          expect(find_field("content_type[content_attributes_attributes][#{idx}][#{attribute}]")).to_not be_checked
        end
      elsif expected_value.to_s.present?
        expect(find_field("content_type[content_attributes_attributes][#{idx}][#{attribute}]").value.to_s).to eq(expected_value.to_s)
      end
    end
  end
end