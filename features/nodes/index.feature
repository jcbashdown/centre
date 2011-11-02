Feature: View Nodes
  As a visitor to the site
  I want to view the current data nodes
  So I can understand the structure of the information

    Scenario: Viewing nodes
      When I go to the home page
      Then I should see "Organisation Name"
      And I should see "App Name"
      And I should see "App" links "6" times
      And I should see "More apps"
      And I should see "Explanatory text"
      And I should see "graphical view"
      And I should see "Highest priority/Strongest point/Most authoritative"
      #And I should see dropdown options (use table)
      And I should see "node title" text "2" times
      And I should see "top links"
      And I should see "edit"
      And I should see "more nodes"
      And I should see "new"
      And I should see "data sources"

