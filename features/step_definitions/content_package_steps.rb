Given(/^there (?:is|are) (\d+) (unpublished )?content packages?\s?(not\s)?(?:assigned to me)?$/) do |n, unpublished, assigned|
  if n.to_i.zero?
    ContentPackage.destroy_all
  end
  @content_packages = [].tap do |arr|
    n.to_i.times do |i|
      if assigned.try(:strip) == 'not'
        arr << FactoryGirl.create(:content_package, :title => "Content package #{i}")
      elsif unpublished.present?
        arr << FactoryGirl.create(:content_package, :title => "Content package #{i}", :status => "draft" )
      else
        arr << FactoryGirl.create(:content_package, :title => "Content package #{i}", :author => @current_user )
      end
    end
  end
  @admin = FactoryGirl.create(:user, :admin)
  @author = FactoryGirl.create(:user, :author)
  @content_package = @content_packages.first
end

Given(/^there is a content package with a parent$/) do
  @parent_content_package = FactoryGirl.create(:content_package)
  @content_package = FactoryGirl.create(:content_package, :parent_id => @parent_content_package.id)
end

Given(/^(?:there is|I create) a content package with the permalink path "(.*?)"$/) do |permalink|
  FactoryGirl.create(:content_package, :permalink_path => permalink)
end

When(/^I go to the sitemap$/) do
  visit content_packages_path
end

When(/^it changes parent$/) do
  parent_content_package = FactoryGirl.create(:content_package)
  @content_package.update_attributes(:parent_id => parent_content_package.id)
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
  select(@content_type)
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
  select(User.first, :from => 'content_package_person_id')
  attach_file('content_package_photo', File.join(Rails.root, 'public/dragonfly/defaults/user.jpg'))
  attach_file('content_package_document', File.join(Rails.root, 'public/dragonfly/defaults/user.jpg'))
  check('content_package_special')
  click_button("Save")
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
  click_button("Save")
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

When(/^I fill in a content attribute with a (character|word) limit$/) do |word_character|
  word = word_character == 'word'
  visit edit_content_package_path(@content_package)
  fill_in("content_package_#{word ? 'text' : 'title'}", :with => (word ? "a " : "a") * 10, :visible => false)
end

Then(/^the (character|word) counter should increase$/) do |word_character|
  expect(page).to have_content("10/30")
end

When(/^I exceed the (character|word) limit of a content attribute$/) do |word_character|
  word = word_character == 'word'
  visit edit_content_package_path(@content_package)
  fill_in("content_package_#{word ? 'text' : 'title'}", :with => (word ? "a " : "a") * 31, :visible => false)
end

Then(/^the (character|word) counter should go red$/) do |word_character|
  word = word_character == 'word'
  expect(find("#content_package_#{word ? 'text' : 'title'}_input")['class']).to include("word-count-exceeded")
end

When(/^I visit its permalink$/) do
  visit "/#{@content_package.permalink_path}".squeeze '/'
end

When(/^I change the content package "(.*?)" to "(.*?)"$/) do |attribute, value|
  @content_package.update(attribute.to_sym => value)
end

When(/^I visit its restful url$/) do
  visit "/content_packages/#{@content_package.id}".squeeze '/'
end

Then(/^I should get redirected to its permalink$/) do
  expect("/#{@content_package.permalink.full_path}".squeeze '/').to eq(current_path)
end

When(/^I visit its full path permalink$/) do
  visit @content_package.permalink.full_path
end

Then(/^I should get an error$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should get redirected to the login page$/) do
  expect(current_path).to eq("/login")
end
