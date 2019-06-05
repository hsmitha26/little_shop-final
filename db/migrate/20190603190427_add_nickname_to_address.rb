class AddNicknameToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :nickname, :string, default: 'home'
  end
end
