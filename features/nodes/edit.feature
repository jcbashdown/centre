Feature: Edit Node
  As a visitor to the site
  I want to edit an individual data node
  So I can change it's content and links
    
    Scenario: Editing nodes
      Given a node has been created
      And I am a user named "User" with an email "test@email.com" and password "TestPass1"
      And I sign in as "test@email.com/TestPass1"
      When I visit the edit node page for the created node
      Then I should see "Title"
      And I should see "Text"
      And I should see "Links In"
      And I should see "Links To"
      
