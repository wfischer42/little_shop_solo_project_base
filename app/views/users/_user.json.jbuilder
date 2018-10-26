json.extract! user, :id, :name, :password_digest, :name, :address, :city, :state, :zip, :role, :active, :created_at, :updated_at
json.url user_url(user, format: :json)
