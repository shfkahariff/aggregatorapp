class AddPublishdateToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :publishdate, :date
  end
end
