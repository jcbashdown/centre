Feature: Edit Node
  As a visitor to the site
  I want to view an individual data node
  So I can see it's content and links
    
    Scenario: Editing nodes
      Given a node has been created
      When I go to the new node page for the created node
      Then I should see "Test"
      Then I should see "Test text"
      
