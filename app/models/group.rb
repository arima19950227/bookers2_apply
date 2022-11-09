class Group < ApplicationRecord

  has_one_attached :image_id

  has_many :group_users
  has_many :users, through: :group_users #グループユーザーテーブルを経由してユーザーテーブルを持ってくる
end
