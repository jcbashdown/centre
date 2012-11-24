#if Rails.env.development?
#  %w[
#     link
#     link/user_link
#     link/user_link/positive_user_link
#     link/user_link/negative_user_link
#     link/question_link
#     link/question_link/positive_question_link
#     link/question_link/negative_question_link
#     link/global_link
#     link/global_link/negative_global_link
#     link/global_link/positive_global_link
#    ].each do |c|
#    require_dependency File.join("app","models","#{c}.rb")
#  end
#end
#
