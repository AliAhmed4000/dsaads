ActiveAdmin.register Banner do
  permit_params :title, :description, :image, :admin_user_id
  
  index do
    column :title
    actions
  end
  form do |f|
    f.inputs do
      f.input :title
      # f.input :description
      f.input :image, :as => :file,:hint => (!f.object.image_url.blank?) ? image_tag(f.object.image_url(:extra_small)) : ''
      f.input :admin_user_id, :input_html => { :value => current_admin_user.id }, as: :hidden
    end
    f.actions
  end
  show :title => proc{|category| category.title} do
    attributes_table do
      row :title
      row "Image" do |image|
        image_tag(image.image_url(:thumb).to_s)
      end
      row :update_at
      row :created_at
    end
  end
end 