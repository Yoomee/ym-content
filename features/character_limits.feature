@admin
Feature: Character limits

@javascript
Scenario: Filling in a content attribute that has a character limit
  Given there is 1 content package
  When I fill in a content attribute with a character limit
  Then the character counter should increase
  @javascript

Scenario: Going over the character limit of a content attribute
  Given there is 1 content package
  When I exceed the character limit of a content attribute
  Then the character counter should go red

@javascript
Scenario: Filling in a content attribute that has a word limit
  Given there is 1 content package
  When I fill in a content attribute with a word limit
  Then the character counter should increase
  @javascript

Scenario: Going over the word limit of a content attribute
  Given there is 1 content package
  When I exceed the word limit of a content attribute
  Then the word counter should go red