Given(/^there (?:is|are) (\d+) content packages?\s?(not\s)?(?:assigned to me)?$/) do |n, assigned|
  if n.to_i.zero?
    ContentPackage.destroy_all
  end
  @content_packages = [].tap do |arr|
    n.to_i.times do |i|
      if assigned.try(:strip) == 'not'
        arr << FactoryGirl.create(:content_package, :title => "Content package #{i}")
      else
        arr << FactoryGirl.create(:content_package, :title => "Content package #{i}", :author => @current_user )
      end
    end
  end
  @admin = FactoryGirl.create(:user, :admin)
  @author = FactoryGirl.create(:user, :author)
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

Then(/^I can't edit the content packages$/) do
  page.all('tr.content-package').each do |tr|
    expect(tr.text).to_not have_content("Edit")
  end
end

Then(/^I can edit the content packages$/) do
  page.all('tr.content-package').each do |tr|
    expect(tr.text).to have_content("Edit")
  end
end

When(/^I fill in the new content package form and submit$/) do
  visit new_content_type_content_package_path(@content_type)
  @content_package = FactoryGirl.build(:content_package, :content_type => @content_type, :author => @admin)
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
  fill_in('content_package_person_id', :with => User.first.id)
  attach_file('content_package_photo', File.join(Rails.root, 'public/dragonfly/defaults/user.jpg'))
  attach_file('content_package_document', File.join(Rails.root, 'public/dragonfly/defaults/user.jpg'))
  check('content_package_special')
  click_button("Update #{@content_package.package_name}")
end

Then(/^the content package should change$/) do
  visit edit_content_package_path(@content_package)
  expect(page).to have_xpath("//img[contains(@src, \"media\")]")
  expect(find('#content_package_special')).to be_checked
  expect(find_field('Title').value).to eq('Modified title')
  expect(find_field('Person').value).to eq(User.first.id.to_s)
end

Given(/^I remove an image$/) do
  visit edit_content_package_path(@content_package)
  check 'content_package_remove_photo'
  click_button("Update #{@content_package.package_name}")
end

Then(/^the image should be removed$/) do
  expect(page).to_not have_xpath("//img[contains(@src, \"media\")]")
end

When(/^I go to the content package$/) do
  visit content_package_path(@content_package)
end

Then(/^I should see all its content$/) do
  @content_package.content_chunks.each do |content_chunk|
    expect(page).to have_content(content_chunk.value)
  end
end

When(/^I discuss the content package$/) do
  visit edit_content_package_path(@content_package)
  click_link('Discussion')
  fill_in('post_text', :with => "Some sample text")
  click_button("Post")
end

Then(/^the discussion count should increase$/) do
  expect(page).to have_content("Some sample text")
end

When(/^I mark the content package as ready to review$/) do
  visit edit_content_package_path(@content_package)
  select("Ready to review", :from => 'content_package[status]')
  click_button("Mark as ready to review")
end

Then(/^it is assigned back to the requester$/) do
  @content_package.reload
  expect(@content_package.author_id).to eq(nil)
  assign_email = ActionMailer::Base.deliveries.last
  expect(assign_email.to).to include(@content_package.requested_by.email)
  expect(assign_email.subject).to have_content(@content_package.name)
end

When(/^I assign it to an author$/) do
  visit edit_content_package_path(@content_package)
  select("#{@author.full_name} (#{@author.role})", :from => 'content_package[author_id]', :visible => false)
  click_button("Save")
end

Then(/^the content package author should change$/) do
  @content_package.reload
  expect(@content_package.author_id).to eq(@author.id)
end

Then(/^the author should be emailed$/) do
  email = ActionMailer::Base.deliveries.last
end

When(/^I go to edit the content package$/) do
  visit edit_content_package_path(@content_package)
end

When(/^I fill in a content attribute with a word limit$/) do
  visit edit_content_package_path(@content_package)
  fill_in('content_package_title', :with => "0123456789")
end

Then(/^the character counter should increase$/) do
  expect(page).to have_content("10/30")
end

When(/^I exceed the word limit of a content attribute$/) do
  visit edit_content_package_path(@content_package)
  fill_in('content_package_title', :with => "0123456789012345678901234567891")
end

Then(/^the character counter should go red$/) do
  puts find('#content_package_title_input')['class']
  find('#content_package_title_input')['class'].include? ".word-count-exceeded"
end