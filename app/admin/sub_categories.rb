ActiveAdmin.register Category, as: "SubCategory" do
  # belongs_to :sub, class_name: "Category", optional: true
  scope :get_sub_categories, default: true
  # scope "Subcategories", :get_sub_categories
  permit_params :sub_category, :title, :sub_category_id

  index title: 'Sub Category' do
    column "Category Title",:sub_category
    column "Sub Category Title",:title
    actions
  end

  form do |f|
    f.inputs "New" do
      f.input :sub_category,  as: :select, collection: Category.get_categories, include_blank: false
      f.input :title
    end
    f.actions
  end
end