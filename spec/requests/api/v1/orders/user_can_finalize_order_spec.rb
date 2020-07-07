RSpec.describe "PUT /api/v1/orders", type: :request do
  let(:product_1) { create(:product, name: 'Pizza', price: 10) }
  let(:product_2) { create(:product, name: 'Kebab', price: 20) }
  let(:order) { create(:order) }

  before do
    order.order_items.create(product: product_1)
    order.order_items.create(product: product_2)

    put "/api/v1/orders/#{order.id}", params: { activity: 'finalize' }
  end

  describe 'PUT /api/v1/orders' do
    it 'responds with success message' do
      expect(JSON.parse(response.body)['message']).to eq 'Your order will be ready in 30 minutes!'
		end

		it 'sets the order attribute "finalized" to true' do
			expect(order.reload.finalized).to eq true
		end
  end
end