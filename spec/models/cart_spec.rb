require 'rails_helper'

RSpec.describe Cart do
  it '.total_count' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })
    expect(cart.total_count).to eq(5)
  end

  it '.add_item' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })

    cart.add_item(1)
    cart.add_item(2)

    expect(cart.contents).to eq({
      '1' => 3,
      '2' => 4
      })
  end

  it '.count_of' do
    cart = Cart.new({})
    expect(cart.count_of(5)).to eq(0)
  end
end
