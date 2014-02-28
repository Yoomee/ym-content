Given(/^there (is|are) (\d+) content packages?$/) do |ia,n|
  if n.to_i.zero?
    ContentPackage.destroy_all
  end
  @content_packages = [].tap do |arr|
    n.to_i.times do |i|
      arr << FactoryGirl.create(:content_package, :title => "Content package #{i}")
    end
  end
  @author = FactoryGirl.create(:author)
  @content_package = @content_packages.first
end

When(/^I go to the sitemap$/) do
  visit content_packages_path
end

Then(/^I see the content packages$/) do
  @content_packages.each do |content_package|
    expect(page).to have_content(content_package.to_s)
  end
end

When(/^I fill in the new content package form and submit$/) do
  visit new_content_type_content_package_path(@content_type)
  @content_package = FactoryGirl.build(:content_package, :content_type => @content_type, :author => @author)
  choose(@content_type)
  fill_in('content_package_name', :with => @content_package.name)
  select(@content_package.author.full_name, :from => 'content_package[author_id]')
  click_button("Finish")
end

Then(/^I am taken to edit the content package$/) do
  @content_package.content_attributes.each do |content_attribute|
    expect(page).to have_content(content_attribute.name)
  end
end

When(/^I update the content package$/) do
  visit edit_content_package_path(@content_package)
  fill_in('content_package_title', :with => 'Modified title')
  attach_file('content_package_photo', File.join(Rails.root, 'public/dragonfly/defaults/user.jpg'))
  attach_file('content_package_document', File.join(Rails.root, 'public/dragonfly/defaults/user.jpg'))
  click_button("Update #{@content_package.package_name}")
end

Then(/^the content package should change$/) do
  visit edit_content_package_path(@content_package)
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