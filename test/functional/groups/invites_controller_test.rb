require File.dirname(__FILE__) + '/../../test_helper'

class Groups::InvitesControllerTest < ActionController::TestCase

  def setup
    @user = User.make
    @group = Group.make
    @group.add_user! @user
  end


  def test_new
    login_as @user
    assert_permission :may_create_group_invite? do
      get :new, :group_id => @group.to_param
    end
    assert_response :success
  end

  def test_create
    login_as @user
    recipient = User.make
    assert_permission :may_create_group_invite? do
      assert_difference 'RequestToJoinUs.count' do
        get :create, :group_id => @group.to_param,
         :recipients => recipient.name
      end
    end
    assert_response :redirect
    assert_redirected_to :action => :index
  end

end
