class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_user, only: [:edit, :update]

  def index
    @groups = Group.all
    @book = Book.new
  end

  def new
    @group = Group.new
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end

  def join
    @group = Group.find(params[:group_id])
    #@group.usersに、current_userを追加しているということ
    @group.users << current_user
    redirect_to  group_path(@group)
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    #@group.usersに、グループ作成者を追加しているということ
    @group.users << current_user
    if @group.save
     redirect_to group_path(@group.id)
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
    if @group.owner_id == current_user.id
      render :edit
    else
      redirect_to group_path(@group)
    end
  end

  def update
     @group = Group.find(params[:id])
     if @group.update(group_params)
        redirect_to group_path(@group)
     else
      render :edit
     end
  end

  def destroy
      @group = Group.find(params[:id])
#current_userは、@group.usersから消されるという記述。
    @group.users.delete(current_user)
    redirect_to group_path(@group)
  end

  def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    ContactMailer.send_mail(@mail_title, @mail_content,group_users).deliver
  end



  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image_id)
  end

  def ensure_current_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
