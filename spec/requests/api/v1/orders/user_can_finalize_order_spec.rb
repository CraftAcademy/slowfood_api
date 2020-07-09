RSpec.describe 'PUT /api/v1/orders with finalized param', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:user_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  let(:pizza) { create(:product, name: 'Pizza', price: 50) }
  let(:falafel) { create(:product, name: 'Falafel', price: 25) }

  let(:order) { create(:order, user: user) }
  let!(:first_order_item) { create(:order_item, order: order, product: pizza) }
  let!(:second_order_item) { create(:order_item, order: order, product: falafel) }

  describe 'successfully' do
    before do 
      put "/api/v1/orders/#{order.id}",
      params: {
        activity: 'finalize'
      },
      headers: user_headers
    end

    it 'responds with 200 status' do
      expect(response.status).to eq 200
    end

    it "responds with success message" do
      expect(response_json["message"]).to eq "Your order will be ready in 30 minutes!"
    end

    it 'sets the order attribute "finalized" to true' do
      expect(order.reload.finalized).to eq true
    end
  end
end