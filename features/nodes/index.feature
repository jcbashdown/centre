Feature: View Nodes
  As a visitor to the site
  I want to view the current data nodes
  So I can understand the structure of the information
    
    @javascript
    Scenario: Viewing nodes
      When I go to the home page
      Then I should see "Organisation Name"
      And I should see "App Name"
      And I should see "App" links "5" times
      And I should see "More Apps"
      #And I should see more apps dropdown options
      And I should see "Explanatory Text"
      And I should see "Visualise"
      #And I should see "Highest priority/Strongest point/Most authoritative"
      #And I should see dropdown options (use table)
      And I should see "Nodes"
      #And I should see "top links"
      #And I should see "edit"
      #And I should see "more nodes"
      And I should see "New Node"
      #And I should see "data sources"
      When I follow "New Node"
      Then I should see "Title"
      And I should see "Text"

