require 'test_helper'
 
class LinkTest < ActiveSupport::TestCase
  test "email" do
    input = "test@example.com"
    link = YmContent::Link.new(input)
    assert_equal link.value, "mailto:#{input}"
  end
  test "internal" do
    input = "content_packages/1"
    link = YmContent::Link.new(input)
    assert_equal link.value, "#{input}"
  end
  test "external with www" do
    input = "www.cake.com"
    link = YmContent::Link.new(input)
    assert_equal link.value, "http://#{input}"
  end
  test "external with slash" do
    input = "cake.co.uk/happiness/chocolate"
    link = YmContent::Link.new(input)
    assert_equal link.value, "http://#{input}"
  end
    test "external with www and slash" do
    input = "www.cake.co.uk/happiness/chocolate"
    link = YmContent::Link.new(input)
    assert_equal link.value, "http://#{input}"
  end
  test "external without www" do
    input = "cake.co.uk"
    link = YmContent::Link.new(input)
    assert_equal link.value, "http://#{input}"
  end
  test "external with scheme" do
    input = "https://www.cake.com"
    link = YmContent::Link.new(input)
    assert_equal link.value, input
  end  
  test "external with subdomain" do
    input = "https://new.cake.com"
    link = YmContent::Link.new(input)
    assert_equal link.value, input
  end
  test "content package" do
    cp = FactoryGirl.create(:content_package)
    input = cp.id.to_s
    link = YmContent::Link.new(input)
    assert_equal link.value, cp
  end
  test "incorrect" do
    input = "mailto: x@example.com"
    link = YmContent::Link.new(input)
    assert_equal link.value, "#{input}"
  end
end