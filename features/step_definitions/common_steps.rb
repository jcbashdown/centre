When /^I go to the home page$/ do
  visit('/')
end

When /^I go to the nodes index$/ do
  visit('/nodes')
end


When /^I go to the new nodes page$/ do
  visit('/nodes/new')
end

Given /^a node has been created$/ do

end

When /^I go to the edit node page for the created node$/ do 
  visit("/nodes/#{@created_node_id}/edit")
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^I should see "([^"]*)" links "([^"]*)" times$/ do |arg1, arg2|
  all(:xpath, "//a[@class='#{arg1.downcase}']").length.should == Integer(arg2)
end

Then /^I should see "([^"]*)" text "([^"]*)" times$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When /^I go to the sign in page$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I go to the sign up page$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I fill in the following:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Given /^I press "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I follow "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When /^I go to the homepage$/ do
  visit('/')
end

Given /^I am on the home page$/ do
  visit('/')
end

Then /^debug$/ do
  require 'ruby-debug'
  debugger
  p "debugging"
end

Then /^show me the page$/ do
  save_and_open_page
end

