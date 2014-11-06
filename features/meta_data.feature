@admin
Feature: Meta data for pages not in the CMS
  As an admin
  In order to add meta data to pages that are not in the cms
  I want to add meta data to a non cms page

  Scenario: Creating meta data
    When I go to the new meta data page
    And I fill in the meta data form
    Then the meta data should be created

  Scenario: Editing meta data
    Given that there is 1 meta data page
    When I go to the meta data page
    And I click on the "Edit" link
    And I update the meta data
    Then the meta data should be updated

  Scenario: Listing meta datas
    Given that there are 3 meta data pages
    When I go to the meta data index page
    Then I see all the meta data pages

  Scenario: Delete meta data
    Given that there is 1 meta data page
    When I go to the meta data page
    And I click on the "Delete" link
    Then the meta data should be deleted

  Scenario: Check that meta data shows up on the page
    Given that there is 1 meta data page
    And the meta data page refers to itself
    When I go to the meta data page
    Then the meta data should be shown in the header
