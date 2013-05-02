
Given /^a node has been created$/ do
  created_node = FactoryGirl.create(:node)
  @created_node_id = created_node.id
end

When /^I visit the new node page for the created node$/ do
  visit("/nodes/#{@created_node_id}")
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

When /^I visit the edit node page for the created node$/ do 
  visit("/nodes/#{@created_node_id}/edit")
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

When /^(?:|I )fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    step %{I fill in "#{name}" with "#{value}"}
  end
end

Then /^I should see "([^"]*)" links "([^"]*)" times$/ do |arg1, arg2|
  all(:xpath, "//a[@class='#{arg1.downcase}']").length.should == Integer(arg2)
end

Then /^I should see "([^"]*)" text "([^"]*)" times$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
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

