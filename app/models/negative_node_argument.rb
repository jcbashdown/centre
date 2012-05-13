class NegativeNodeArgument < Argument
  after_update :update_whole_argument

  def update_from_below(argument)
    #use glu methods to update (move to argument?) - delete the args block for subject id if present and then re add the new content for that arg
    #update attributes and then this will trigger for super nodes again
  end

  protected

  def update_whole_argument
=begin
    if subject_type == "GlobalNodeUser"
      global_link_user_tos.each do |glu|
        if glu.value == 1
          glu.global_node_user_to.positive_node_argument.update_from_below(self)
        elsif glu.value == -1
          glu.global_node_user_to.negative_node_argument.update_from_below(self)
        end
      end
    elsif subject_type == "GlobalNode"
    
    end
=end
  end
end
