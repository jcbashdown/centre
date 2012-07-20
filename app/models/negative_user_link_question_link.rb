#class NegativeUserLinkQuestionLink < ActiveRecord::Base
#  belongs_to :user_link, :class_name => Link::UserLink::NegativeUserLink
#  belongs_to :question_link, :class_name => Link::QuestionLink::NegativeQuestionLink, :counter_cache => :users_count
#end
