require 'spec_helper'
require 'models/context_link_spec_helper'
require 'models/context_node_spec_helper'

describe ContextLink do
  describe 'create' do
    context 'when validations fail' do
      it 'should not create all the associated nodes' do
        pending
      end
    end
    context 'creating context nodes through context links' do
      context 'when there is no existing context_link' do
        before do
          @question = FactoryGirl.create(:question)
          @user = FactoryGirl.create(:user)
          @gnu1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
          @state_hash = {
                          :context_link => {:number_created => 1},
                          :global_link => {
                                            :number_created => 1,
                                            :users_count => 1,
                                            :activation => true
                                          },
                          :question_link => {
                                              :number_created => 1,
                                              :users_count => 1,
                                              :activation => true
                                            },
                          :user_link => {
                                          :number_created => 1,
                                          :users_count => 0
                                        },
                          :context_node => {
                                             :number_created => 0,
                                             :find_or_create_calls => 2 
                                           },
                          :new_global_node_to => {
                                            :upvotes_count=> 1
                                          },
                          :new_global_node_from => {
                                            :upvotes_count=> 0
                                          },
                          :new_question_node_to => {
                                              :upvotes_count => 1
                                            },
                          :new_question_node_from => {
                                              :upvotes_count => 0
                                            },
                          :new_user_node_to => {
                                          :upvotes_count => 1
                                        },
                          :new_user_node_from => {
                                          :upvotes_count => 0
                                        }
                        }
        @node_state_hash = {
                             :context_node => {
                                                :number_created => 1
                                              },
                             :global_node => {
                                               :number_created => 1,
                                               :number_existing => 1,
                                               :users_count => 1,
                                               :is_conclusion => false
                                             },
                             :question_node => {
                                                 :number_created => 1,
                                                 :number_existing => 1,
                                                 :users_count => 1,
                                                 :is_conclusion => false
                                               },
                             :user_node => {
                                             :number_created => 1,
                                             :number_existing => 1,
                                             :users_count => 1
                                           }
                           }
          #do we need a conclusion status?
          @params = {:user=>@user, :question => @question, :global_node_to_id => @gnu1.global_node.id, :context_node_from_title => 'Title'}
          @perform = "ContextLink::PositiveContextLink.create(@params)"
        end
        it_should_behave_like 'a context link creating links', "Positive"
        it_should_behave_like 'context node creating nodes'
      end
    end
    context 'when it is a self link' do
      it 'should not be valid' do
        pending
      end
    end
    context 'when there is no existing context_link' do
      before do
        @question = FactoryGirl.create(:question)
        @user = FactoryGirl.create(:user)
        @gnu1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
        @gnu2 = ContextNode.create(:title => 'test', :question => @question, :user => @user)
        @state_hash = {
                        :context_link => {:number_created => 1},
                        :global_link => {
                                          :number_created => 1,
                                          :users_count => 1,
                                          :activation => true
                                        },
                        :question_link => {
                                            :number_created => 1,
                                            :users_count => 1,
                                            :activation => true
                                          },
                        :user_link => {
                                        :number_created => 1,
                                        :users_count => 0
                                      },
                        :context_node => {
                                           :number_created => 0,
                                           :find_or_create_calls => 2 
                                         },
                        :new_global_node_to => {
                                          :upvotes_count=> 1
                                        },
                        :new_global_node_from => {
                                          :upvotes_count=> 0
                                        },
                        :new_question_node_to => {
                                            :upvotes_count => 1
                                          },
                        :new_question_node_from => {
                                            :upvotes_count => 0
                                          },
                        :new_user_node_to => {
                                        :upvotes_count => 1
                                      },
                        :new_user_node_from => {
                                        :upvotes_count => 0
                                      }
                      }
        @params = {:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id} 
      end
      it_should_behave_like 'a context link creating links', "Positive"
      context 'when creating a duplicate context_link' do
        before do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          @state_hash = {
                          :context_link => {:number_created => 0},
                          :global_link => {
                                            :number_created => 0,
                                            :users_count => 1,
                                            :activation => true
                                          },
                          :question_link => {
                                              :number_created => 0,
                                              :users_count => 1,
                                              :activation => true
                                            },
                          :user_link => {
                                          :number_created => 0,
                                          :users_count => 0
                                        },
                          :context_node => {
                                             :number_created => 0,
                                             :find_or_create_calls => 2
                                           },
                          :new_global_node_to => {
                                            :upvotes_count=> 1
                                          },
                          :new_global_node_from => {
                                            :upvotes_count=> 0
                                          },
                          :new_question_node_to => {
                                              :upvotes_count => 1
                                            },
                          :new_question_node_from => {
                                              :upvotes_count => 0
                                            },
                          :new_user_node_to => {
                                          :upvotes_count => 1
                                        },
                          :new_user_node_from => {
                                          :upvotes_count => 0
                                        }
                        }
          @params = {:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id} 
        end
        it_should_behave_like 'a context link creating links', "Positive"
      end
      context 'when creating a context_link in a different question' do
        before do
          @question2 = FactoryGirl.create(:question, :name => 'new question')
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          @state_hash = {
                          :context_link => {:number_created => 1},
                          :global_link => {
                                            :number_created => 0,
                                            :users_count => 1,
                                            :activation => true
                                          },
                          :question_link => {
                                              :number_created => 1,
                                              :users_count => 1,
                                              :activation => true
                                            },
                          :user_link => {
                                          :number_created => 0,
                                          :users_count => 0
                                        },
                          :context_node => {
                                             :number_created => 2,
                                             :find_or_create_calls => 2
                                           },
                          :new_global_node_to => {
                                            :upvotes_count=> 1
                                          },
                          :new_global_node_from => {
                                            :upvotes_count=> 0
                                          },
                          :new_question_node_to => {
                                              :upvotes_count => 1
                                            },
                          :new_question_node_from => {
                                              :upvotes_count => 0
                                            },
                          :new_user_node_to => {
                                          :upvotes_count => 1
                                        },
                          :new_user_node_from => {
                                          :upvotes_count => 0
                                        }
                        }
          @question = FactoryGirl.create(:question, :name => 'another new question')
          @params = {:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id} 
        end
        it_should_behave_like 'a context link creating links', "Positive"
      end
      context 'when creating equivalents' do
        before do
          @state_hash = {
                          :context_link => {:number_created => 1},
                          :global_link => {
                                            :number_created => 1,
                                            :users_count => 1,
                                            :activation => true
                                          },
                          :question_link => {
                                              :number_created => 1,
                                              :users_count => 1,
                                              :activation => true
                                            },
                          :user_link => {
                                          :number_created => 1,
                                          :users_count => 0
                                        },
                          :context_node => {
                                             :number_created => 0,
                                             :find_or_create_calls => 2 
                                           },
                          :new_global_node_to => {
                                            :upvotes_count=> 0,
                                            :equivalents_count=> 0
                                          },
                          :new_global_node_from => {
                                            :upvotes_count=> 0,
                                            :equivalents_count=> 0
                                          },
                          :new_question_node_to => {
                                              :upvotes_count => 0,
                                              :equivalents_count=> 0
                                            },
                          :new_question_node_from => {
                                              :upvotes_count => 0,
                                              :equivalents_count=> 0
                                            },
                          :new_user_node_to => {
                                          :upvotes_count => 0,
                                          :equivalents_count=> 0
                                        },
                          :new_user_node_from => {
                                          :upvotes_count => 0,
                                          :equivalents_count=> 0
                                        }
                        }
          @params = {:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id} 
        end
        it_should_behave_like 'a context link creating links', "Equivalent"
      end
    end
  end

  describe 'update' do
    before do
      @question = FactoryGirl.create(:question)
      @user = FactoryGirl.create(:user)
      @gnu1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
      @gnu2 = ContextNode.create(:title => 'test', :question => @question, :user => @user)
    end
    context 'when there is only this context_link' do
      before do
        @context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @state_hash = {
                        :context_link => {:extras_updated => 1},
                        :global_link => {
                                          :number_destroyed => -1,
                                          :number_created => 1
                                        },
                        :old_global_link => {
                                          :users_count => nil,
                                          :activation => nil
                                        },
                        :new_global_link => {
                                          :users_count => 1,
                                          :activation => true
                                        },
                        :question_link => {
                                            :number_destroyed => -1,
                                            :number_created => 1,
                                          },
                        :old_question_link => {
                                            :users_count => nil,
                                            :activation => nil
                                          },
                        :new_question_link => {
                                            :users_count => 1,
                                            :activation => true
                                          },
                        :user_link => {
                                        :number_updated => 1,
                                        :users_count => 0
                                      },
                        :new_global_node_to => {
                                          :upvotes_count=> 0,
                                          :downvotes_count=> 1
                                        },
                        :old_global_node_to => {
                                          :upvotes_count=> 1,
                                          :downvotes_count=> 0
                                        },
                        :new_global_node_from => {
                                          :upvotes_count=> 0,
                                          :downvotes_count=> 0
                                        },
                        :old_global_node_from => {
                                          :upvotes_count=> 0,
                                          :downvotes_count=> 0
                                        },
                        :new_question_node_to => {
                                            :upvotes_count => 0,
                                            :downvotes_count=> 1
                                          },
                        :old_question_node_to => {
                                            :upvotes_count => 1,
                                            :downvotes_count=> 0
                                          },
                        :new_question_node_from => {
                                            :upvotes_count => 0,
                                            :downvotes_count=> 0
                                          },
                        :old_question_node_from => {
                                            :upvotes_count => 0,
                                            :downvotes_count=> 0
                                          },
                        :new_user_node_to => {
                                        :upvotes_count => 0,
                                        :downvotes_count=> 1
                                      },
                        :old_user_node_to => {
                                        :upvotes_count => 1,
                                        :downvotes_count=> 0
                                      },
                        :new_user_node_from => {
                                        :upvotes_count => 0,
                                        :downvotes_count=> 0
                                      },
                        :old_user_node_from => {
                                        :upvotes_count => 0,
                                        :downvotes_count=> 0
                                      }
                      }
      end
      it_should_behave_like 'a @context_link updating links', "Negative", "Positive"
    end
  end

  describe 'destroy' do
    before do
      @question = FactoryGirl.create(:question)
      @user = FactoryGirl.create(:user)
      @gnu1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
      @gnu2 = ContextNode.create(:title => 'test', :question => @question, :user => @user)
    end
    context 'when there is only this context_link' do
      before do
        @context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @state_hash = {
                        :context_link => {:number_destroyed => -1},
                        :global_link => {
                                          :number_destroyed => -1,
                                          :users_count => nil,
                                          :activation => nil
                                        },
                        :question_link => {
                                            :number_destroyed => -1,
                                            :users_count => nil,
                                            :activation => nil
                                          },
                        :user_link => {
                                        :number_destroyed => -1,
                                        :users_count => nil
                                      },
                        :new_global_node_to => {
                                          :upvotes_count=> 0
                                        },
                        :new_global_node_from => {
                                          :upvotes_count=> 0
                                        },
                        :new_question_node_to => {
                                            :upvotes_count => 0
                                          },
                        :new_question_node_from => {
                                            :upvotes_count => 0
                                          },
                        :new_user_node_to => {
                                        :upvotes_count => 0
                                      },
                        :new_user_node_from => {
                                        :upvotes_count => 0
                                      }
                      }
      end
      it_should_behave_like 'a @context_link deleting links', "Positive"
    end
    context 'when there is this context_link and another for a different global' do
      before do
        @context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @question_two = FactoryGirl.create(:question, :name => 'test global')
        @context_link_two = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question_two, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @state_hash = {
                        :context_link => {:number_destroyed => -2},
                        :global_link => {
                                          :number_destroyed => -1,
                                          :users_count => nil,
                                          :activation => nil
                                        },
                        :question_link => {
                                            :number_destroyed => -2,
                                            :users_count => nil,
                                            :activation => nil
                                          },
                        :user_link => {
                                        :number_destroyed => -1,
                                        :users_count => nil
                                      },
                        :new_global_node_to => {
                                          :upvotes_count=> 0
                                        },
                        :new_global_node_from => {
                                          :upvotes_count=> 0
                                        },
                        :new_question_node_to => {
                                            :upvotes_count => 0
                                          },
                        :new_question_node_from => {
                                            :upvotes_count => 0
                                          },
                        :new_user_node_to => {
                                        :upvotes_count => 0
                                      },
                        :new_user_node_from => {
                                        :upvotes_count => 0
                                      }
                      }
      end
      it_should_behave_like 'a @context_link deleting links', "Positive"
    end
    context 'when there is this context_link and another for a different user' do
      before do
        @user_two = FactoryGirl.create(:user, :email => "test@user.com")
        @context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @context_link_two = ContextLink::PositiveContextLink.create(:user=>@user_two, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @state_hash = {
                        :context_link => {:number_destroyed => -1},
                        :global_link => {
                                          :number_destroyed => 0,
                                          :users_count => 1,
                                          :activation => true
                                        },
                        :question_link => {
                                            :number_destroyed => 0,
                                            :users_count => 1,
                                            :activation => true
                                          },
                        :user_link => {
                                        :number_destroyed => -1,
                                        :users_count => nil
                                      },
                        :new_global_node_to => {
                                          :upvotes_count=> 1
                                        },
                        :new_global_node_from => {
                                          :upvotes_count=> 0
                                        },
                        :new_question_node_to => {
                                            :upvotes_count => 1
                                          },
                        :new_question_node_from => {
                                            :upvotes_count => 0
                                          },
                        :new_user_node_to => {
                                        :upvotes_count => 0
                                      },
                        :new_user_node_from => {
                                        :upvotes_count => 0
                                      }
                      }
      end
      it_should_behave_like 'a @context_link deleting links', "Positive"
    end
  end
  describe 'something about node destroy through link' do
    context 'when the node was created directly' do
      pending
    end
    context 'when node created through link' do
      context 'and only the cl to be destroyed supports this creation' do
        pending
      end
      context 'and more than the cl to be destroyed support this creation' do
        pending
      end
    end
  end

end
