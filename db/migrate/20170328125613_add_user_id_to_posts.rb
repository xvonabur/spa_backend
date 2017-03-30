# frozen_string_literal: true
class AddUserIdToPosts < ActiveRecord::Migration[5.0]
  def up
    remove_column :posts, :username
    add_column :posts, :user_id, :integer
  end

  def down
    add_column :posts, :username, :string
    remove_column :posts, :user_id
  end
end
