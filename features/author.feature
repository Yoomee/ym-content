@author
Feature: CMS author
  In order to create great content
  As an author
  I want to manage content assigned to me

Scenario: Viewing a list of content packages I need to write
  Given there are 3 content packages assigned to me
  When I go to the dashboard
  Then I see the content packages

Scenario: Viewing a list of my content packages
  Given there are 3 content packages assigned to me
  When I go to the sitemap
  Then I can edit the content packages

Scenario: Set content package as ready to review
  Given there is 1 content package assigned to me
  When I mark the content package as ready to review
  Then it is assigned back to the requester
