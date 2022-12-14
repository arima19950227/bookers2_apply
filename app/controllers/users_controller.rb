class UsersController < ApplicationController
   before_action :ensure_correct_user, only: [:update, :edit]

#DM機能の記述。
  def show
    #レコードからユーザー1人1人の情報を持ってくる
    @user = User.find(params[:id])
    #roomがcreateされた時に、現在ログインしているユーザーと、
    #「チャットへ」を押されたユーザーの両方をEntriesテーブルに記録する必要があるので、
    #whereメソッドでそのユーザーを探している
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)

    #showページのユーザーが現在ログインしているユーザーではないというunlessの条件
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
      @userEntry.each do |u|
      #roomsが作成されている場合と作成されていない場合に条件分岐
        if cu.room_id == u.room_id then
          @isRoom = true
          @roomId = cu.room_id
        end
      end
     end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

 private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

 def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to new_user_session_path
    end
 end

end
