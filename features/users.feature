@admin
Feature: CMS user management
  In order to manage users
  As an admin
  I want a user management interface

@javascript
Scenario: Creating a user
  Given there are 0 users
  When I fill in the new cms user form and submit
  Then the user is created

@javascript
Scenario: Editing a user
  Given there are 1 users
  When I fill in the edit cms user form and submit
  Then the user is updated

@javascript
Scenario: Editing a user
  Given there are 4 users
  When I visit the cms user index 
  Then I see the cms users

@javascript
Scenario: Make a user inactive
  Given there are 1 users
  When I visit the cms user index 
  And I set the user as inactive
  Then the user is inactive

