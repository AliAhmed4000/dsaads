class AddSellerIdToRevision < ActiveRecord::Migration[5.2]
  def change
    rename_column :revisions, :user_id, :buyer_id
    add_column :revisions, :seller_id, :integer
  end
end
