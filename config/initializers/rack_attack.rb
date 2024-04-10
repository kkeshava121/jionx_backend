class Rack::Attack
  # Throttle requests to 5 requests per second per IP
  # throttle('185.251.89.193', limit: 5, period: 1.second) do |req|
  #   req.ip
  # end
end