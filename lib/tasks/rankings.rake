require "page_ranker"

namespace :rank do

  desc "Calculate page rank"
  task :page_rank => :environment do
    PageRanker.build_and_save_rank
  end
  
end
