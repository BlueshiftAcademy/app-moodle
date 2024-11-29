@core @core_badges @javascript
Feature: Manage badges
  In order to manage badges in the system
  As an admin
  I need to be able to edit, copy, enable/disable access, delete and award badges

  Background:
    Given the following "core_badges > Badge" exists:
      | name           | Badge #1                     |
      | status         | 0                            |
      | version        | 1                            |
      | language       | en                           |
      | description    | Test badge description       |
      | image          | badges/tests/behat/badge.png |
      | imageauthorurl | http://author.example.com    |
      | imagecaption   | Test caption image           |

  Scenario: Copy a badge
    Given I log in as "admin"
    And I navigate to "Badges > Manage badges" in site administration
    And I press "Copy" action in the "Badge #1" report row
    And I should see "Copy of Badge #1"
    And I press "Save changes"
    And I click on "Back" "button"
    Then the following should exist in the "reportbuilder-table" table:
      | Name             | Badge status  |
      | Badge #1         | Not available |
      | Copy of Badge #1 | Not available |

  Scenario: Edit a badge
    Given I log in as "admin"
    And I navigate to "Badges > Manage badges" in site administration
    And I press "Edit" action in the "Badge #1" report row
    And I set the field "Name" to "New Badge #1"
    And I press "Save changes"
    And I click on "Back" "button"
    Then the following should exist in the "reportbuilder-table" table:
      | Name          | Badge status  |
      | New Badge #1  | Not available |

  Scenario: Delete a badge
    Given I log in as "admin"
    And I navigate to "Badges > Manage badges" in site administration
    And I press "Delete" action in the "Badge #1" report row
    And I press "Delete and remove existing issued badges"
    Then I should see "There are no matching badges available for users to earn."

  Scenario: Enable and disable access to a badge
    Given I log in as "admin"
    And I navigate to "Badges > Manage badges" in site administration
    And I press "Edit" action in the "Badge #1" report row
    And I select "Criteria" from the "jump" singleselect
    And I set the field "type" to "Manual issue by role"
    And I set the field "Manager" to "1"
    And I press "Save"
    And I navigate to "Badges > Manage badges" in site administration
    And I press "Enable access" action in the "Badge #1" report row
    And I should see "Changes in badge access"
    And I press "Continue"
    And I should see "Access to the badges was successfully enabled"
    Then the following should exist in the "reportbuilder-table" table:
      | Name      | Badge status  |
      | Badge #1  | Available     |
    And I press "Disable access" action in the "Badge #1" report row
    And I should see "Access to the badges was successfully disabled"
    And the following should exist in the "reportbuilder-table" table:
      | Name      | Badge status  |
      | Badge #1  | Not available |

  Scenario: Award a badge
    Given the following "users" exist:
      | username | firstname | lastname | email             |
      | user1    | User      | One      | user1@example.com |
    When I log in as "admin"
    And I navigate to "Badges > Manage badges" in site administration
    And I press "Edit" action in the "Badge #1" report row
    And I select "Criteria" from the "jump" singleselect
    And I set the field "type" to "Manual issue by role"
    And I set the field "Manager" to "1"
    And I press "Save"
    And I navigate to "Badges > Manage badges" in site administration
    And I press "Enable access" action in the "Badge #1" report row
    And I press "Continue"
    And I press "Award badge" action in the "Badge #1" report row
    And I set the field "potentialrecipients[]" to "Admin User (moodle@example.com),User One (user1@example.com)"
    And I press "Award badge"
    And I navigate to "Badges > Manage badges" in site administration
    Then the following should exist in the "Badges" table:
      | Name      | Badge status  | Recipients |
      | Badge #1  | Available     | 2          |
    And I click on "2" "link" in the "Badge #1" "table_row"
    And the following should exist in the "generaltable" table:
      | -1-        |
      | Admin User |
      | User One   |