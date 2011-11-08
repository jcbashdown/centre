Feature: View Nodes
  As a visitor to the site
  I want to view the homepage
  So I can understand navigate the app
    
    Scenario: Viewing nodes
      When I go to the home page
      Then I should see "Organisation Name"
      And I should see "Centre"
      And I should see "App" links "5" times
      And I should see "More Apps"
      #And I should see more apps dropdown options
      And I should see "Visualise"
      And I should see "Nodes"
      #And I should see "data sources"

