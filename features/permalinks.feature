@non-nested
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

@allow-rescue
Scenario: I visit a permalink that doesn't exist I get a 404
  Given there is 1 content package
  When I visit "/non-existent-permalink"
  Then I should get a 404

@allow-rescue
Scenario: I can visit a content package without a permalink
  Given there is 1 content package
  When I visit "/non-existent-permalink"
  Then I should get a 404
