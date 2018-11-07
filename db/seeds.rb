require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

admin = create(:admin)
user = create(:user)
merchant_1 = create(:merchant, email:"merch", password: "merch")

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)

inv_item_1 = create(:inventory_item, merchant: merchant_1)
inv_item_2 = create(:inventory_item, merchant: merchant_2)
inv_item_3 = create(:inventory_item, merchant: merchant_3)
inv_item_4 = create(:inventory_item, merchant: merchant_4)
create_list(:inventory_item, 10, merchant: merchant_1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_2, price: 2, quantity: 1)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_3, price: 3, quantity: 1)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_4, price: 4, quantity: 1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_2, price: 2, quantity: 1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_2, price: 2, quantity: 1)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_3, price: 3, quantity: 1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, inventory_item: inv_item_2, price: 2, quantity: 1)
