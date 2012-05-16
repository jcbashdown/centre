class Argument < ActiveRecord::Base
  attr_accessible :content, :subject_id, :subject_type
  before_create :set_default_attributes
  #after_save :update_whole_argument
  belongs_to :subject, :polymorphic => true
  delegate :global_link_user_tos, :to => :subject 

  def friendly_argument
    list = content.gsub("\n", "")
    list.gsub!("</positive>", "<positive-up>1</positive-up>")
    list.gsub!("<positive>", "<positive>1</positive>")
    list.gsub!("<positive>", "</global-node-user><positive>")
    list.gsub!("</positive-up></global-node-user>", "</positive-up>")
    list.gsub!("<positive/>", "<positive>0</positive>")
    list.gsub!("</negative>", "<negative-up>1</negative-up>")
    list.gsub!("<negative>", "<negative>1</negative>")
    list.gsub!("<negative>", "</global-node-user><negative>")
    list.gsub!("</negative-up></global-node-user>", "</negative-up>")
    list.gsub!("<negative/>", "<negative>0</negative>")
    list_doc = Nokogiri::XML(%Q|<pos>|+list+%Q|</pos>|) {|config| config.default_xml.noblanks}
    list_array = []
    list_doc.children[0].children.each do |element|
      xml_element = element.to_xml
      list_array << Morph.from_xml(%Q|<pos>|+xml_element+%Q|</pos>|)
    end
    list_array
  end

  def update_whole_argument
    if type == "NegativeNodeArgument" || type == "PositiveNodeArgument"
      if subject_type == "GlobalNodeUser"
        global_link_user_tos.each do |glu|
  	  if glu.value == 1
  	    glu.update_node_to_xml
  	  elsif glu.value == -1
  	    glu.update_node_to_xml
  	  end
        end
      elsif subject_type == "GlobalNode"
      
      end
    end
  end

  protected
  def set_default_attributes
    self.content = ""
  end

end
