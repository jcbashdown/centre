#class PositiveUserLinkQuestionLink < ActiveRecord::Base
#  belongs_to :user_link, :class_name => Link::UserLink::PositiveUserLink
#  belongs_to :question_link, :class_name => Link::QuestionLink::PositiveQuestionLink, :counter_cache => :users_count
#end
