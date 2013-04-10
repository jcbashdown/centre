class RandomLinkMap

  attr_accessor :questions, :users, :groups, :nodes, :links

  def initialize counts_hash={}, link_count_only_subject_node = false
    if counts_hash.any?
      generate_questions counts_hash[:question_count]
      generate_groups counts_hash[:group_count]
      generate_users counts_hash[:user_count]
      generate_nodes counts_hash[:node_count]
      generate_links counts_hash[:link_count_per_node], link_count_only_subject_node
    end
  end

  [:questions, :users, :groups, :nodes, :links].each do |accessor|
    define_method accessor do
      if instance_variable_get(:"@#{accessor}")
        instance_variable_get(:"@#{accessor}")
      else
        instance_variable_set(:"@#{accessor}", [])
      end
    end
  end

  private

  def generate_questions question_count
    question_count.times do |n|
      questions << FactoryGirl.create(:question, :name => n.to_s)
    end
  end

  def generate_groups group_count
    group_count.times do |n|
      groups << FactoryGirl.create(:group, :title => n.to_s)
    end
  end

  def generate_users user_count
    user_count.times do |n|
      user = FactoryGirl.create(:user, :name => n.to_s)
      groups.each do |group|
        if (rand(1..2) % 2) == 0
          group.users << user
        end
      end
      users << user
    end
  end

  def generate_nodes node_count
    node_count.times do |n|
      new_node = nil
      while(new_node==nil)
        node = ContextNode.create(
                                   :user=>users[rand(users.count)], 
                                   :question=>questions[rand(questions.count)], 
                                   :title => n.to_s, 
                                   :is_conclusion => (rand(1..2) % 2) == 0
                                 )
        if node
          new_node = node
        end
      end
      nodes << new_node
    end
  end

  def generate_links link_count_per_node, link_count_only_subject_node
    if link_count_only_subject_node
      make_associations_for_subject nodes.last, link_count_per_node
    else
      nodes.each do |node|
        make_associations_for_subject node, link_count_per_node
      end
    end
  end

  def make_associations_for_subject subject, link_count_per_node
    link_count_per_node.times do
      other_node = nil
      while(other_node==nil) do
        other_node = nodes[rand(nodes.count)]
        other_node = nil if other_node == subject
      end
      if (rand(1..2) % 2) == 0
        params = {:global_node_to_id => subject.global_node_id, :global_node_from_id => other_node.global_node_id}
      else
        params = {:global_node_to_id => other_node.global_node_id, :global_node_from_id => subject.global_node_id}
      end
      type_num = rand(1..3)
      if type_num == 1
        loop_link_until_created Link::UserLink::PositiveUserLink, params
      elsif type_num == 2
        loop_link_until_created Link::UserLink::NegativeUserLink, params
      else type_num == 3
        loop_link_until_created Link::UserLink::NoLinkUserLink, params
      end
    end
  end

  def loop_link_until_created type, params
    new_link = nil
    while(new_link==nil)
      params = params.merge({:user=>users[rand(users.count)], :question => questions[rand(questions.count)]})
      link = type.send(:create, params)
      if link
        new_link = link
      end
    end
    links << new_link
  end

end
