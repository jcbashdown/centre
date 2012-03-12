class UserGlobalsLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :globals_link

  after_destroy :decrement_link_counter_cache
  after_create :save_globals_link

  def decrement_link_counter_cache
    GlobalsLink.decrement_counter( 'users_count', globals_link.id )
  end 

  def save_globals_link
    globals_link.save!
  end
end
