Feature: View Nodes
  As a visitor to the site
  I want to view the current data nodes
  So I can understand the structure of the information
    
    Scenario: Viewing nodes
      When I go to the nodes index
      Then I should see "Explanatory Text"
      Then I should see "New Node"
      
