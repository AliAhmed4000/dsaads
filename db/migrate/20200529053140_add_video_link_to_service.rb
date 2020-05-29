class AddVideoLinkToService < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :video_link, :string
  end
end
