class RemoveNicknameToAddress < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :nickname, :string
  end
end
