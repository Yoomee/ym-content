Before('@editor') do
  step "I am logged in"
end

After do |scenario|
  save_and_open_page if scenario.failed?
end