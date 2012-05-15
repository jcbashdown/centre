module NodesHelper
  def argument_helper(argument)
    argument_html = ""
    argument.each do |element|
      Rails.logger.info(element)
      Rails.logger.info(element.positive)
      if element.global_node_user
        argument_html+=%Q|<li>#{element.global_node_user.title}</li>|
      elsif element.positive == "1"
        argument_html+=%Q|<ul>|
      elsif element.positive_up == "1"
        argument_html+=%Q|</ul>|
      elsif element.negative == "1"
        argument_html+=%Q|<ul>|
      elsif element.negative_up == "1"
        argument_html+=%Q|</ul>|
      else
        ""
      end
    end
    raw argument_html
  end
end
