Given(/^there (is|are) (\d+) content packages?$/) do |ia,n|
  if n.to_i.zero?
    ContentPackage.destroy_all
  end
  @content_packages = [].tap do |arr|
    n.to_i.times do |i|
      arr << FactoryGirl.create(:content_package, :title => "Content package #{i}")
    end
  end
  @content_package = @content_packages.first
end

When(/^I go to the list of content packages$/) do
  visit content_packages_path
end

Then(/^I see the content packages$/) do
  @content_packages.each do |content_package|
    expect(page).to have_content(content_package.to_s)
  end
end

When(/^I fill in the new content package form and submit$/) do
  visit new_content_type_content_package_path(@content_type)
  @content_package = FactoryGirl.build(:content_package)
  fill_in('content_package_slug', :with => @content_package.slug)
  click_button('Create Content package')
end

Then(/^the content package is created$/) do
  visit content_packages_path
  expect(page).to have_content(@content_package.to_s)
end

When(/^I update the content package$/) do
  visit edit_content_package_path(@content_package)
  fill_in('content_package_slug', :with => 'modified_slug')
  fill_in('content_package_title', :with => 'Modified title')
  click_button('Update Content package')
end

Then(/^the content package should change$/) do
  visit edit_content_package_path(@content_package)
  expect(find_field('Slug').value).to eq('modified_slug')
  expect(find_field('Title').value).to eq('Modified title')
end

When(/^I go to the content package$/) do
  visit content_package_path(@content_package)
end

Then(/^I should see all its content$/) do
  @content_package.content_chunks.each do |content_chunk|
    expect(page).to have_content(content_chunk.value)
  end
end