When(/^I go to the new meta data page$/) do
  visit new_meta_data_path
end

When(/^I fill in the meta data form$/) do
  @meta_data = FactoryGirl.build(:meta_data)
  fill_in 'meta_data_page_slug', with: @meta_data.page_slug
  fill_in 'meta_data_title', with: @meta_data.title
  fill_in 'meta_data_description', with: @meta_data.description
  fill_in 'meta_data_keywords', with: @meta_data.keywords
  click_button 'Save'
end

Then(/^the meta data should be created$/) do
  page.should have_content @meta_data.page_slug
  page.should have_content @meta_data.title
  page.should have_content @meta_data.description
  page.should have_content @meta_data.keywords
end

Given(/^that there (?:is|are) (\d+) meta data pages?$/) do |x|
  @meta_datas = FactoryGirl.create_list(:meta_data, x.to_i)
  @meta_data = @meta_datas.first
end

When(/^I go to the meta data page$/) do
  visit meta_data_path(@meta_data)
end

When(/^I update the meta data$/) do
  fill_in 'meta_data_page_slug', with: 'Updated page slug'
  fill_in 'meta_data_title', with: 'Updated title'
  fill_in 'meta_data_description', with: 'Updated description'
  fill_in 'meta_data_keywords', with: 'Updated keywords'
  click_button 'Save'
end

Then(/^the meta data should be updated$/) do
  page.should have_content 'Updated page slug'
  page.should have_content 'Updated title'
  page.should have_content 'Updated description'
  page.should have_content 'Updated keywords'
end

When(/^I go to the meta data index page$/) do
  visit meta_datas_path
end

Then(/^I see all the meta data pages$/) do
  @meta_datas.each do |meta_data|
    page.should have_content meta_data.page_slug
    page.should have_content meta_data.title
    page.should have_content meta_data.description
    page.should have_content meta_data.keywords
  end
end

Then(/^the meta data should be deleted$/) do
  Metadata.count.should eq(0)
end

Given(/^the meta data page refers to itself$/) do
  @meta_data.page_slug = "meta_datas/#{@meta_data.id}"
  @meta_data.save
end

Then(/^the meta data should be shown in the header$/) do
  page.title.should have_content @meta_data.title
  has_css?("meta[property='og:title'][content='#{@meta_data.title}']", visible: false)
  has_css?("meta[property='og:description'][content='#{@meta_data.description}']", visible: false)
  has_css?("meta[name='keywords'][content='#{@meta_data.keywords}']", visible: false)
end
