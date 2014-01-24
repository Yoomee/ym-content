Feature: CMS editor
  In order to curate great content
  As an editor
  I want to manage the content

Scenario: Viewing a list of content types
  Given there are 3 content types
  And I am logged in
  When I go to the list of content types
  Then I see the content types