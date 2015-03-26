@admin
Feature: CMS admin
  In order to create great content
  As an admin
  I want to manage the CMS

Scenario: Viewing a list of content types
  Given there are 3 content types
  When I go to the list of content types
  Then I see the content types

@javascript
Scenario: Creating a content type
  Given there are 0 content types
  When I fill in the new content type form and submit
  Then the content type is created

Scenario: Updating a content type
  Given there is 1 content type
  When I update the content type
  Then the content type should change

Scenario: Duplicating a content type
  Given there are 1 content type
  When I duplicate the content type
  Then I see a new content type with all the same attributes

Scenario: Adding the content attributes of one content type to another
  Given there are 2 content types
  When I duplicate the first content type onto the second
  Then I see a second content type with all the attributes of the first

Scenario: Viewing a list of content packages
  Given there are 3 content packages
  When I go to the sitemap
  Then I see the content packages

Scenario: Creating a content package
  Given there is 1 content type
  And there are 0 content packages
  When I fill in the new content package form and submit
  Then I am taken to edit the content package

Scenario: Updating a content package
  Given there is 1 content package
  When I update the content package
  Then the content package should change

Scenario: Removing an image
  Given there is 1 content package
  And I update the content package
  And I remove an image
  Then the image should be removed

Scenario: Viewing a content package
  Given there is 1 content package
  When I go to the content package
  Then I should see all its content

Scenario: Viewing a list of persona groups
  Given there are 3 persona groups
  When I go to the list of personas
  Then I see the persona groups

Scenario: Viewing a list of personas
  Given there are 3 personas
  When I go to the list of personas
  Then I see the personas

Scenario: Creating a persona
  Given there are 0 personas
  And there is 1 persona group
  When I fill in the new persona form and submit
  Then the persona is created

@javascript
@wip
Scenario: Discussing a content package
  Given there is 1 content package
  When I discuss the content package
  Then the discussion count should increase

@javascript
Scenario: I can assign a content package to an author
  Given there is 1 content package
  When I assign it to an author
  Then the content package author should change
  And the author should be emailed