RSpec.describe "POST /api/v1/orders", type: :request do
  let!(:product_1) { create(:product, name: 'Pizza') }
  let!(:product_2) { create(:product, name: 'Kebab') }

	before do
		post '/api/v1/orders', params: { product_id: product_1.id }
		@order_id = JSON.parse(response.body)['order_id']
	end

  describe 'POST /api/v1/orders' do
    it 'responds with success message' do
      expect(JSON.parse(response.body)['message']).to eq 'The product has been added to your order'
    end

    it 'responds with order id' do
      order = Order.find(@order_id)
      expect(JSON.parse(response.body)['order_id']).to eq order.id
    end
  end

  describe 'PUT /api/orders/:id' do
    before do
      put "/api/v1/orders/#{@order_id}", params: { product_id: product_2.id }
      @order = Order.find(@order_id)
    end

    it 'adds another product to order if request is a PUT and param id of the order is present' do
      expect(@order.order_items.count).to eq 2
    end

    it 'responds with order id' do
      expect(JSON.parse(response.body)['order_id']).to eq @order.id
    end
  end
end