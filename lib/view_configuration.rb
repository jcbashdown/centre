module ViewConfiguration
  
  def accepted_options
    HashWithIndifferentAccess.new({
            :current_node => true,
            :nodes_question => true,
            :nodes_user => true,
            :nodes_query => true,
            :argument_user => true,
            :argument_question => true,
            :links_to_question => true,
            :links_to_user => true,
            :links_to_query => true,
            :links_from_question => true,
            :links_from_user => true,
            :links_from_query => true
          })
  end

end
