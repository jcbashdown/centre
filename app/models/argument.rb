class Argument < ActiveRecord::Base
  attr_accessible :content, :subject_id, :subject_type
  after_create :set_default_attributes

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

  belongs_to :subject, :polymorphic => true

  protected
  def set_default_attributes
    self.content = ""
    save
  end
end
