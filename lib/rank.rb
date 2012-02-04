class Rank
  
  #Math library faster?
  # add result to hash of matrices, apply one or the other bit of code, save at end, restrict to question sets to save processing first (say n = 150 matrices)/apply heuristics.
  def build_matrix
    #link value is positive links is proportion pos links = for 3 positive 2 negative 3/5
    # so if node one links to node two 5 times upvotes (node_one.link_tos == 5). and 3 of the five are positive #Link.find.where(node_to = node_two.id AND value = 1).count
    matrix = []
    Node.all.each do |node|
      to_id = node.id
      from_id = self.id
      unless to_id == from_id
        down = 0.0
        up = 0.0
        if link = Link.where('node_from = #{from_id} AND node_to = #{to_id} AND value = -1')
          down = Float(link.users_count)
        end
        if link = Link.where('node_from = #{from_id} AND node_to = #{to_id} AND value = 1')
          up = Float(link.users_count)
        end
        matrix << fraction_of_link = up/(up+down)
      end
    end
    matrix
  end
  
  #call when new node? when saved - then store matrix
  def add_to_or_edit_matrix
  end
end
