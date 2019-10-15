# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
user = AdminUser.find_by_email('admin@example.com')
banner = user.build_banner(:image => Rails.root.join("app/assets/images/outlinesiteagain.docx.jpg").open,title: "banner",description: "This is my Banner")
banner.save
titles = ["Cars & Truck", "Classic Cars", "Boat & WaterCraft", "Vehicle Parts, Tries & Accessories", "MotorCycles", "Heavy Equiments"]
images = ["app/assets/images/classic_cars.jpeg","app/assets/images/classic_cars.jpeg","app/assets/images/classic_cars.jpeg","app/assets/images/classic_cars.jpeg","app/assets/images/classic_cars.jpeg","app/assets/images/classic_cars.jpeg"]
(0..5).to_a.each do |key|
  Category.create(:title => titles[key],:image => Rails.root.join(images[key]).open)
end 