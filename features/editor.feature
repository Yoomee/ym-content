@editor
Feature: CMS editor
  In order to curate great content
  As an editor
  I want to manage the content

Scenario: Viewing a list of content types
  Given there are 3 content types
  When I go to the list of content types
  Then I see the content types

@javascript
Scenario: Creating a content type
  Given there are 0 content types
  When I fill in the new content type form and submit
  Then the content type is created

Scenario: Viewing a list of content packages
  Given there are 3 content packages
  When I go to the list of content packages
  Then I see the content packages

Scenario: Creating a content package
  Given there is 1 content type
  Given there are 0 content packages
  When I fill in the new content package form and submit
  Then the content package is created

Scenario: Updating a content package
  Given there is 1 content package
  When I update the content package
  Then the content package should change