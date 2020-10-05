module ActiveAdminHelpers
	
  def order_refund_statuses(user)
    user.is_seller? ? ["resolved", "more_information_requested"] : ["refund_request_accepted", "refund_request_declined"] 
  end
end
