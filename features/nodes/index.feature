Feature: View Nodes
  As a visitor to the site
  I want to view the current data nodes
  So I can understand the structure of the information
    
    Scenario: Viewing nodes
      When I go to the nodes index page
      Then I should see "Explanatory Text"
      And I am a user named "User" with an email "test@email.com" and password "TestPass1"
      And I am not logged in
      And I go to the sign in page
      And I fill in "Email" with "test@email.com"
      And I fill in "Password" with "TestPass1"
      And I press "Submit"
      Then I should see "New Node"
      
