Given(/^there (is|are) (\d+) personas?$/) do |ia,n|
  if n.to_i.zero?
    Persona.destroy_all
  end
  @personas = [].tap do |arr|
    n.to_i.times do
      arr << FactoryGirl.create(:persona)
    end
  end
  @persona = @personas.first
end

When(/^I go to the list of personas$/) do
  visit personas_path
end

Then(/^I see the personas$/) do
  @personas.each do |persona|
    expect(page).to have_content(persona.to_s)
  end
end

When(/^I fill in the new persona form and submit$/) do
  visit new_persona_path
  @persona = FactoryGirl.build(:persona)
  select(@persona_group.to_s)
  fill_in('persona_name', :with => @persona.name)
  fill_in('persona_category', :with => @persona.category)
  fill_in('persona_age', :with => @persona.age)
  fill_in('persona_summary', :with => @persona.summary)
  click_button('Create Persona')
end

Then(/^the persona is created$/) do
  visit personas_path
  expect(page).to have_content(@persona.to_s)
end