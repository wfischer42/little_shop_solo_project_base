json.extract! item, :id, :user_id, :name, :description, :price, :inventory, :active, :created_at, :updated_at
json.url item_url(item, format: :json)
