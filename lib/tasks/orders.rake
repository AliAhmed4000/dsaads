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
end