if Rails.env.development?
  $redis = Redis.new
else
  $redis = Redis.new#(:host => ENV["REDIS_URL"])
end