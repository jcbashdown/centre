Feature: New Node
  As a visitor to the site
  I want to create an individual data node
  So I can input it's content and links
    
    Scenario: New node
      When I go to the new nodes page 
      Then I should see "Title"
      Then I should see "Text"
      And I should see "Links In"
      And I should see "Links To"
      
      
