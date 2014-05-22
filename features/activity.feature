@admin
Feature: Record activity for a content package
  In order to see the history of a content package
  The cms should record activity

Scenario: When a content package is created an activity should be recorded
  Given there is 1 content type
  And there are 0 content packages
  When I fill in the new content package form and submit
  Then I should see the "created" activity

Scenario: When a content package is updated an activity should be recorded
  Given there is 1 content packages
  When I update the content package
  And I go to edit the content package
  Then I should see the "updated" activity

Scenario: I can see recent activity on the dashboard
  Given there are 10 content packages
  When I go to the dashboard
  Then I should see the 5 activity items

@javascript
Scenario: I can see older activity on the dashboard
  Given there are 10 content packages
  When I go to the dashboard
  And I choose to see older activity
  Then I should see the 10 activity items

