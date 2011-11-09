Feature: Edit Node
  As a visitor to the site
  I want to edit an individual data node
  So I can change it's content and links
    
    Scenario: Editing nodes
      Given a node has been created
      When I go to the edit node page for the created node
      Then I should see "Title"
      Then I should see "Text"
      
