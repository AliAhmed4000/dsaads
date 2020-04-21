namespace :orders do
	desc "Order Completed"
	task completed_date: :environment do
		orders = OrderItem.completed.where('completed_at is null')
		orders.each do |o|
			o.update_column('completed_at',o.updated_at + 14.days)
		end 
	end

	task packages: :environment do
		packages = Package.where('service_id=?',6)
		packages.each do |p|
			p.destroy
		end 
	end

	task packages_revision: :environment do
		packages = Package.all
		packages.each do |p|
			p.update_column('revision_number',Package.revision_numbers['unlimited'])
		end 
	end

	task order_revision: :environment do
		orders = OrderItem.all
		orders.each do |o|
			o.update_column('revision_no',Package.revision_numbers['unlimited'])
		end 
	end

	# task review_revision: :environment do
	# 	revisions = Revision.all
	# 	revisions.each do |r|
	# 		r.reviews.build(
	# 			:order_item_id => r.order_item_id,
	# 			:buyer_id => r.order_item.order.user_id,
	# 			:seller_id => r.order_item.package.service.user_id,
	# 			:packge_id => r.order_item.package.id,
	# 			:type => "SellerReview"
	# 		)
	# 	end 
	# end

	# task order_cancel_revision: :environment do
	# 	orders = OrderCancel.all
	# 	orders.each do |o|
	# 			o.reviews.build(
	# 			:order_item_id => o.order_item_id,
	# 			:buyer_id => o.order_item.order.user_id,
	# 			:seller_id => o.order_item.package.service.user_id,
	# 			:packge_id => o.order_item.package.id,
	# 			:type => 
	# 		)
	# 	end 
	# end

	task services_title: :environment do
		services = Service.all
		services.each do |s|
			s.update_column('search_title','I can ' + s.title)
		end
	end 
end  