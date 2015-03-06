@nested
Feature: CMS Permalinks
  In order to give content packages nice pretty urls
  As a CMS admin
  the site should user permalinks to provide linkable urls

Scenario: I visit a content package via its permalink
  Given there is 1 content package
  When I visit its permalink
  Then I should see all its content

Scenario: I visit a content package via a case insensitive permalink
  Given there is 1 content package
  When I change the content package "permalink_path" to "a-lower-case-permalink"
  When I visit "/a-LoWeR-cAsE-pErMaLiNk"
  Then I should see all its content

Scenario: I can view a page by its original permalink even after it has changed
  Given there is 1 content package
  When I change the content package "permalink_path" to "new-permalink"
  And I visit "/new-permalink"
  Then I should see all its content

Scenario: I can visit a content package by its /content_package/:id and get redirected to its permalink
  Given there is 1 content package
  When I visit its restful url
  Then I should get redirected to its permalink

Scenario: I can change a content package parent and the original permalink will redirect to the new one
 Given there is a content package with a parent
 When it changes parent
 And I visit "/my-nice-permalink-1/my-nice-permalink-2/"
 Then I should get redirected to its permalink

@non_nested
Scenario: I visit a nested content package via its permalink
  Given there is a content package with a parent
  When I visit its full path permalink
  Then I should see all its content

@nested
Scenario: I visit a nested content package via its full path permalink
  Given there is a content package with a parent
  When I visit its full path permalink
  Then I should see all its content

@allow-rescue
Scenario: I visit a permalink that doesn't exist I get a 404
  Given there is 1 content package
  When I visit "/non-existent-permalink"
  Then I should get a 404
