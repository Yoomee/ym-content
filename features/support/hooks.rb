Before('@editor') do
  step "I am logged in as an admin"
end

Before('@author') do
  step "I am logged in as an author"
end

After do |scenario|
  save_and_open_page if scenario.failed?
end