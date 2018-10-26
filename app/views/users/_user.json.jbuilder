json.extract! user, :id, :name, :passowrd_digest, :name, :address, :city, :state, :zip, :role, :active, :created_at, :updated_at
json.url user_url(user, format: :json)
