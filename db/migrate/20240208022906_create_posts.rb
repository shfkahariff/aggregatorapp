class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :headlines
      t.string :titleurl

      t.timestamps
    end
  end
end
