class RandomLinkMap

  attr_accessor :questions, :users, :groups, :nodes, :links, :report, :concluding_nodes

  def initialize counts_hash={}, link_count_only_subject_node_last_user = false, report = false
    @report = report
    if counts_hash.any?
      generate_questions counts_hash[:question_count]
      generate_groups counts_hash[:group_count]
      generate_users counts_hash[:user_count]
      generate_nodes counts_hash[:node_count]
      generate_links counts_hash[:link_count_per_node], link_count_only_subject_node_last_user
    end
  end

  [:questions, :users, :groups, :nodes, :links, :concluding_nodes].each do |accessor|
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
      question = FactoryGirl.create(:question, :name => n.to_s)
      questions << question.id
      p "QUESTIONS" if report
      p questions if report
      p questions.count if report
      question = nil
    end
  end

  def generate_groups group_count
    group_count.times do |n|
      group = FactoryGirl.create(:group, :title => n.to_s)
      groups << group.id
      p "GROUPS" if report
      p groups if report
      p groups.count if report
      group = nil
    end
  end

  def generate_users user_count
    user_count.times do |n|
      user = FactoryGirl.create(:user, :name => n.to_s)
      groups.each do |group_id|
        group = Group.find group_id
        if (rand(1..2) % 2) == 0
          group.users << user
        end
        group = nil
      end
      users << user.id
      p "USERS" if report
      p users if report
      p users.count if report
      user = nil
    end
  end

  def generate_nodes node_count
    node_count.times do |n|
      new_node = nil
      while(new_node==nil)
        node = Node::UserNode.create(
                                   :user=>User.find(users[rand(users.count)]), 
                                   :question=>Question.find(questions[rand(questions.count)]), 
                                   :title => n.to_s, 
                                   :is_conclusion => (rand(1..2) % 2) == 0
                                 )
        if node
          new_node = node
          node = nil
        end
      end
      concluding_nodes << new_node if new_node.is_conclusion
      nodes << new_node.id
      p "NODES" if report
      p nodes if report
      p nodes.count if report
      new_node = nil
    end
  end

  def generate_links link_count_per_node, link_count_only_subject_node_last_user
    if link_count_only_subject_node_last_user
      subject = Node::UserNode.find(nodes.last)
      make_associations_for_subject Node::UserNode.find(nodes.last), link_count_per_node, subject.user
    else
      nodes.each do |node|
        make_associations_for_subject Node::UserNode.find(node), link_count_per_node
      end
    end
  end

  def make_associations_for_subject subject, link_count_per_node, user=nil
    link_count_per_node.times do
      type_num = rand(1..3)
      if type_num == 1
        loop_link_until_created subject, Link::UserLink::PositiveUserLink, user
      elsif type_num == 2
        loop_link_until_created subject, Link::UserLink::NegativeUserLink, user
      else type_num == 3
        loop_link_until_created subject, Link::UserLink::NoLinkUserLink, user
      end
    end
    subject = nil
  end

  def loop_link_until_created subject, type, user=nil
    new_link = nil
    while(new_link==nil)
      user ||= User.find(users[rand(users.count)]) 
      other_node = nil
      while(other_node==nil) do
        other_node = Node::UserNode.find(nodes[rand(nodes.count)])
        other_node = nil if other_node == subject
      end
      if (rand(1..2) % 2) == 0
        params = {:global_node_to_id => subject.global_node_id, :global_node_from_id => other_node.global_node_id}
      else
        params = {:global_node_to_id => other_node.global_node_id, :global_node_from_id => subject.global_node_id}
      end
      params = params.merge({user: user, :question => Question.find(questions[rand(questions.count)])})
      link = type.send(:create, params)
      if link && link.id
        new_link = link
      end
    end
    links << new_link.id
    p "LINKS" if report
    p links if report
    p links.count if report
    new_link = nil
  end

end
