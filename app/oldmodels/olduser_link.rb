#class UserLink < ActiveRecord::Base
#  belongs_to :user
#  belongs_to :link
#
#  after_destroy :decrement_link_counter_cache
#
#  def decrement_link_counter_cache
#    Link.decrement_counter( 'users_count', link.id )
#  end 
#end
