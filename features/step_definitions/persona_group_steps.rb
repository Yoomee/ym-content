Given(/^there (is|are) (\d+) persona groups?$/) do |ia,n|
  if n.to_i.zero?
    PersonaGroup.destroy_all
  end
  @persona_groups = [].tap do |arr|
    n.to_i.times do
      arr << FactoryGirl.create(:persona_group)
    end
  end
  @persona_group = @persona_groups.first
end