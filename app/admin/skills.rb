ActiveAdmin.register Skill do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name,:admin_user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :services_count]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  form do |f|
    f.inputs do
      f.input :name
      f.input :admin_user_id, :input_html => { :value => current_admin_user.id }, as: :hidden
    end
    f.actions
  end
  # index do
  #   column :title
  #   actions
  # end
end
