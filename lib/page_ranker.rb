require "matrix"
class PageRanker

  def self.build_and_save_rank
    matrix = PageRanker.build_link_matrix
    p 1
    p matrix
    matrix = PageRanker.row_stochastic(matrix)
    p 2
    p matrix
    matrix = matrix.transpose
    p 3
    p matrix
    matrix = PageRanker.eigenvector(matrix)
    p 4
    p matrix
    matrix = PageRanker.normalize(matrix)
    p 5
    p matrix
    #matrix = PageRanker.normalize(PageRanker.eigenvector(PageRanker.row_stochastic(matrix).transpose))
    index = 1
    matrix.each do |e|
      node = Node.find(index)
      while node.ignore
        index+=1
        node = Node.find(index)
      end
      p node
      node.update_attributes!(:page_rank=>e)
      index+=1
    end
  end

  def self.build_link_matrix
    array = []
    Node.all.each do |node|
      unless node.ignore
        array << node.build_link_array
      end
    end
    Matrix.rows(array)
  end


  #First, you construct an adjacency matrix. An adjacency matrix is just a matrix of what is linking to what.
  
  #[0, 1, 1, 1, 1, 0, 1]
  #[1, 0, 0, 0, 0, 0, 0]
  #[1, 1, 0, 0, 0, 0, 0]
  #[0, 1, 1, 0, 1, 0, 0]
  #[1, 0, 1, 1, 0, 1, 0]
  #[1, 0, 0, 0, 1, 0, 0]
  #[0, 0, 0, 0, 1, 0, 0]
  
  #This example is based on the wikipedia description, http://en.wikipedia.org/wiki/PageRank#Algorithm
  
  #So, for example, row 1 is what Page ID=1 is linking to, ie, pages 2, 3, 4, 5, and 7.
  
  #Let's call the matrix m1,
  
  #m1 = Matrix[[ 0.0,1.0,1.0,1.0,1.0,0.0,1.0],[1.0,0.0,0.0,0.0,0.0,0.0,0.0],[1.0,1.0,0.0,0.0,0.0,0.0,0.0],[0.0,1.0,1.0,0.0,1.0,0.0,0.0],[1.0,0.0,1.0,1.0,0.0,1.0,0.0],[1.0,0.0,0.0,0.0,1.0,0.0,0.0],[0.0,0.0,0.0,0.0,1.0,0.0,0.0]]
  
  #I've got it in floating point so it'll end up in floating point...
  
  #Now, the first thing you need to do is compute the row-stochastic matrix, which is the same thing as getting each row to add up to 1.
  
  def self.row_stochastic(matrix)
    x = 0
    row_total = []
    while x < matrix.row_size
      y = 0
      row_total << 0
      while y < matrix.row_size
        row_total[x] += matrix.row(x)[y]
        y += 1
      end
      x += 1
    end
    a1 = matrix.to_a
    x = 0
    while x < matrix.row_size
      y = 0
      while y < matrix.row_size
        a1[x][y] = a1[x][y]/row_total[x]
        y += 1
      end
      x += 1
    end
    Matrix[*a1]
  end
  
  #You'd end up with a matrix like this:
  
  #puts row_stochastic(m1)
  
  #[[0.0, 0.2, 0.2, 0.2, 0.2, 0.0, 0.2]
  #[1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
  #[0.5, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0]
  #[0.0, 0.33, 0.33, 0.0, 0.33, 0.0, 0.0]
  #[0.25, 0.0, 0.25, 0.25 , 0.0, 0.25, 0.0]
  #[0.5, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0]
  #[0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0]]
  
  #Now, you need to transpose it before you continue.
  
  #row_stochastic(m1).transpose
  
  #Now, you've got to compute the principal eigenvector. I won't go in to the details of what that is, but here's the method, and #what it returns.
  
  def self.eigenvector(matrix)
   i = 0
   a = []
   while i < matrix.row_size
     a << [1]
     i += 1
   end
   eigen_vector = Matrix[*a]
   i = 0
   while i < 100
     eigen_vector = matrix*eigen_vector
     eigen_vector = eigen_vector / eigen_vector.row(0)[0]
     i += 1
   end
   eigen_vector
  end
  
  #puts eigenvector(row_stochastic(m1).transpose)
  
  #[[1.0], [0.547368421052632], [0.463157894736842], [0.347368421052632], [0.589473684210526], [0.147368421052632], [0.2 ]]
  
  #Now, just normalize it, by having it all add up to 1.
  
  def self.normalize(matrix)
    i = 0
    t = 0
    while i < matrix.row_size
      t += matrix.column(0)[i]
      i += 1
    end
    matrix = matrix/t
  end
  
  #Giving, in the end,
  
  #puts normalize(eigenvector(row_stochastic(m1).transpose))
  
  #[[0.303514376996805], [0.166134185303514], [0.140575079872204], [0.105431309904153], [0.178913738019169], [0.0447284345047923 ], [0.060702875399361]]
  
  #Math library faster?
  # add result to hash of matrices, apply one or the other bit of code, save at end, restrict to question sets to save processing first (say n = 150 matrices)/apply heuristics.
  
  #call when new node? when saved - then store matrix
  def self.add_to_or_edit_matrix
  end
end