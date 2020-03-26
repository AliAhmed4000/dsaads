namespace :currency_conversion do
	desc "Currency Conversion"
	task convert_currency: :environment do
		response1 = Curl.get("https://free.currconv.com/api/v7/convert?q=USD_EUR&compact=ultra&apiKey=#{ENV['MONEY']}")
	  json_response1 = JSON.parse(response1.body_str)
		unit1 = json_response1["USD_EUR"] 
	  Currency.find_by_country('USD_EUR').update_column('currency',unit1)
	  response2 = Curl.get("https://free.currconv.com/api/v7/convert?q=USD_GBP&compact=ultra&apiKey=#{ENV['MONEY']}")
	  json_response2 = JSON.parse(response2.body_str)
		unit2 = json_response2["USD_GBP"]
		Currency.find_by_country('USD_GBP').update_column('currency',unit2)
	  response3 = Curl.get("https://free.currconv.com/api/v7/convert?q=USD_CAD&compact=ultra&apiKey=#{ENV['MONEY']}")
		json_response3 = JSON.parse(response3.body_str)
		unit3 = json_response3["USD_CAD"]
		Currency.find_by_country('USD_CAD').update_column('currency',unit3)
		response4 = Curl.get("https://free.currconv.com/api/v7/convert?q=USD_PKR&compact=ultra&apiKey=#{ENV['MONEY']}")
		json_response4 = JSON.parse(response4.body_str)
		unit4 = json_response4["USD_PKR"]
		Currency.find_by_country('USD_CAD').update_column('currency',unit4)
	end

	desc "Country Currency"
	task country_currency: :environment do
	  country1 = Currency.new(country: 'USD_CAD')
	  country1.save
	  country2 = Currency.new(country: 'USD_EUR')
	  country2.save
	  country3 = Currency.new(country: 'USD_GBP')
	  country3.save
	  response1 = Curl.get("https://free.currconv.com/api/v7/convert?q=USD_EUR&compact=ultra&apiKey=#{ENV['MONEY']}")
	  json_response1 = JSON.parse(response1.body_str)
		unit1 = json_response1["USD_EUR"] 
	  Currency.find_by_country('USD_EUR').update_column('currency',unit1)
	  response2 = Curl.get("https://free.currconv.com/api/v7/convert?q=USD_GBP&compact=ultra&apiKey=#{ENV['MONEY']}")
	  json_response2 = JSON.parse(response2.body_str)
		unit2 = json_response2["USD_GBP"]
		Currency.find_by_country('USD_GBP').update_column('currency',unit2)
	  response3 = Curl.get("https://free.currconv.com/api/v7/convert?q=USD_CAD&compact=ultra&apiKey=#{ENV['MONEY']}")
		json_response3 = JSON.parse(response3.body_str)
		unit3 = json_response3["USD_CAD"]
		Currency.find_by_country('USD_CAD').update_column('currency',unit3)
		response4 = Curl.get("https://free.currconv.com/api/v7/convert?q=USD_PKR&compact=ultra&apiKey=#{ENV['MONEY']}")
		json_response4 = JSON.parse(response4.body_str)
		unit4 = json_response4["USD_PKR"]
		Currency.find_by_country('USD_CAD').update_column('currency',unit4)
  end
end