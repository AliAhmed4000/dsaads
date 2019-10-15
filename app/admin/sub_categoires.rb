ActiveAdmin.register SubCategory do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :description, :category_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :services_count]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # index do
  #   column :title
  #   actions
  # end

  # form do |f|
    # if params[:action] == "new"
    #   states = CS.states('AD').invert
    # elsif params[:action] == "create" || params[:action] == "update" 
    #   country = f.object.country
    #   states = CS.states(country).invert
    #   state = f.object.state
    # elsif params[:action] == "edit"
    #   country = CS.countries.key(f.object.country)
    #   states = CS.states(country).invert
    #   state = CS.states(country).key(f.object.state)
    # end
    # f.inputs do
      # f.input :title
      # f.input :image, :as => :file,:hint => (!f.object.image_url.blank?) ? image_tag(f.object.image_url(:extra_small)) : ''
      # f.input :country, as: :select, collection: CS.countries.invert, include_blank: false, :selected => country
      # f.input :state, as: :select, collection: states, include_blank: false, :selected => state
    # end
    # f.actions
  # end

  # show :title => proc{|category| category.title} do
  #   attributes_table do
  #     row :title
  #     row "Image" do |image|
  #       image_tag(image.image_url(:thumb).to_s)
  #     end
  #     row :update_at
  #     row :created_at
  #   end
  # end
end
