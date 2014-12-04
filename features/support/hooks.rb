Before('@admin') do
  step "I am logged in as an admin"
end

Before('@editor') do
  step "I am logged in as an admin"
end

Before('@author') do
  step "I am logged in as an author"
end

Before('@non-nested') do
  YmContent.config.nested_permalinks = false
end

Before('@nested') do
  YmContent.config.nested_permalinks = true
end

After do |scenario|
  save_and_open_page if scenario.failed?
end