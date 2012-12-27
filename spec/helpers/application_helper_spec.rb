require 'spec_helper'

describe ApplicationHelper do

  describe "format_url_for_pagination" do
    it 'should return the url with all params except page deleted' do
      page_num = 3
      url = nodes_path(:query => 123, :all_page => "#{page_num}", :minimum => "5.6")
      helper.format_url_for_pagination(url, :all_page, page_num).should == nodes_path(:all_page => "#{page_num}")
    end
  end
end
