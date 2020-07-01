ActiveAdmin.register Client do
  permit_params :heading, :instruction, :image
  form do |f|
    f.inputs do
      f.input :heading
      f.input :instruction, as: :text
      f.input :image
    end
    f.submit
  end
  show :heading => proc{|client| client.heading} do
    attributes_table do
      row :instruction
      row "Image" do |image|
        image_tag(image.image_url(:thumb).to_s)
      end
      row :update_at
      row :created_at
    end
  end
end