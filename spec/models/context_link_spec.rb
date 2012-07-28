require 'spec_helper'
require 'models/context_link_spec_helper'

describe ContextLink do
  describe 'create' do
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
                                        :users_count => 0,
                                        :activation => true
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
                                          :users_count => 0,
                                          :activation => true
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
                                          :users_count => 0,
                                          :activation => true
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
          @question = FactoryGirl.create(:question, :name => 'new question')
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
                                          :users_count => 0,
                                          :activation => true
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
        end
        it_should_behave_like 'a context link creating links', "Equivalent"
      end
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
        @context_link_attrs = @context_link.attributes
        @lu_attrs = {:node_from_id => @context_link.user_node_from.id, :node_to_id => @context_link.user_node_to.id, :user_id => @user.id}
        @gl_attrs = {:node_from_id => @context_link.question_node_from.id, :node_to_id => @context_link.question_node_to.id, :question_id => @question.id}
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
                                        :users_count => nil,
                                        :activation => nil
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
        @question_two = FactoryGirl.create(:question, :name => 'test global')
        @context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @context_link_attrs = @context_link.attributes
        @lu_attrs = {:node_from_id => @context_link.user_node_from.id, :node_to_id => @context_link.user_node_to.id, :user_id => @user.id}
        @gl_attrs = {:node_from_id => @context_link.question_node_from.id, :node_to_id => @context_link.question_node_to.id, :question_id => @question.id}
        @context_link_two = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question_two, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
      end
      it 'should destroy the context_link' do
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should_not be_nil
        @context_link.destroy
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should be_nil
      end

      it 'should decrement the context_links count by 1' do
        expect {
          @context_link.destroy
        }.to change(ContextLink, :count).by(-1)
      end

      it 'should destroy the gl' do
        Link::QuestionLink.where(@gl_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::QuestionLink.where(@gl_attrs)[0].should be_nil
      end

      it 'should decrement the gl count by 1' do
        expect {
          @context_link.destroy
        }.to change(Link::QuestionLink, :count).by(-1)
      end

      it 'should decrement the lus context_link count by 1' do
        Link::UserLink.count.should == 1
        Link::UserLink.where(@lu_attrs)[0].users_count.should == 0
        @context_link.destroy
        Link::UserLink.count.should == 1
        Link::UserLink.where(@lu_attrs)[0].users_count.should == 0 
      end

      it 'should destroy the lu' do
        Link::UserLink.where(@lu_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::UserLink.where(@lu_attrs)[0].should be_nil
      end

      it 'should not decrement the lu count' do
        expect {
          @context_link.destroy
        }.to change(Link::UserLink, :count).by(-1)
      end
      
      it 'should update the caches' do
        node_to = Node::GlobalNode.where(:title => @gnu2.global_node.title)[0]
        gnu_to = ContextNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to = Node::QuestionNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id)[0]
        nu_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to.upvotes_count.should == 1
        nu_to.upvotes_count.should == 1 
        node_to.upvotes_count.should == 1 
        @context_link.destroy
        node_to = Node.where(:title => @gnu2.global_node.title)[0]
        gnu_to = ContextNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to = Node::QuestionNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id)[0]
        nu_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to.upvotes_count.should == 0
        nu_to.upvotes_count.should == 1 
        node_to.reload.upvotes_count.should == 1 
      end
    end
    context 'when there is this context_link and another for a different user' do
      before do
        @user_two = FactoryGirl.create(:user, :email => "test@user.com")
        @context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @context_link_attrs = @context_link.attributes
        @lu_attrs = {:node_from_id => @context_link.user_node_from.id, :node_to_id => @context_link.user_node_to.id, :user_id => @user.id}
        @gl_attrs = {:node_from_id => @context_link.question_node_from.id, :node_to_id => @context_link.question_node_to.id, :question_id => @question.id}
        Link::QuestionLink.where(@gl_attrs)[0].users_count.should == 1 
        @context_link_two = ContextLink::PositiveContextLink.create(:user=>@user_two, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        Link::QuestionLink.where(@gl_attrs)[0].users_count.should == 2 
      end
      it 'should destroy the context_link' do
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should_not be_nil
        @context_link.destroy
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should be_nil
      end

      it 'should decrement the context_links count by 1' do
        expect {
          @context_link.destroy
        }.to change(ContextLink, :count).by(-1)
      end

      it 'should destroy the gl' do
        Link::QuestionLink.where(@gl_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::QuestionLink.where(@gl_attrs)[0].should_not be_nil
      end

      it 'should decrement the gl count by 1' do
        expect {
          @context_link.destroy
        }.to change(Link::GlobalLink, :count).by(0)
      end

      it 'should decrement the gls context_link count by 1' do
        Link::QuestionLink.count.should == 1
        Link::QuestionLink.where(@gl_attrs)[0].users_count.should == 2
        @context_link.destroy
        Link::QuestionLink.count.should == 1
        Link::QuestionLink.where(@gl_attrs)[0].users_count.should == 1 
      end

      it 'should not destroy the lu' do
        Link::UserLink.where(@lu_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::UserLink.where(@lu_attrs)[0].should be_nil
      end

      it 'should not decrement the lu count' do
        expect {
          @context_link.destroy
        }.to change(Link::UserLink, :count).by(-1)
      end
      
      it 'should update the caches' do
        node_to = Node::GlobalNode.where(:title => @gnu2.global_node.title)[0]
        gnu_to = ContextNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to = Node::QuestionNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id)[0]
        nu_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        node_to.upvotes_count.should == 2
        gn_to.upvotes_count.should == 2
        nu_to.upvotes_count.should == 1
        @context_link.destroy
        node_to = Node::GlobalNode.where(:title => @gnu2.global_node.title)[0]
        gnu_to = ContextNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to = Node::QuestionNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id)[0]
        nu_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        node_to.reload.upvotes_count.should == 1 
        gn_to.upvotes_count.should == 1
        nu_to.upvotes_count.should == 0 
      end

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
