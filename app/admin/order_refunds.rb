ActiveAdmin.register OrderRefund do
  permit_params :admin_reason,:status
  # actions :all
  # batch_action :destroy, false
  # config.clear_action_items!
  config.clear_action_items!
  index do
    column :id
    column :order_item_id
    column :user_reason
    column :admin_reason
    column :status
    column :created_at
    column :updated_at
    actions defaults: false do |action|
      if action.pending?
      	item 'Waiting For Response',edit_admin_order_refund_path(action), class: "view_link member_link"
        #(order_refund 'Approved', status_order_refund_path(order_refund, status: 'approved'), class: 'view_link member_link', method: :put, "data-confirm" => "Are you sure you want to approve this refund.") 
        #(order_refund 'Rejected', status_order_refund_path(order_refund, status: 'rejected'), class: 'view_link member_link', method: :put, "data-confirm" => "Are you sure you want to reject this refund.")
    	end 
    end
  end

  form do |f|
    f.inputs do
      f.input :admin_reason, label: "Reason"
      f.input :status
    end
    f.actions
  end
end