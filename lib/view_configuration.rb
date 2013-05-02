module ViewConfiguration
  
  def accepted_options
    HashWithIndifferentAccess.new({
            :current_node => true,
            :nodes_question => true,
            :nodes_user => true,
            :nodes_query => true,
            :argument_user => true,
            :argument_question => true,
            :links_question => true,
            :links_user => true,
            :links_query => true
          })
  end

end
