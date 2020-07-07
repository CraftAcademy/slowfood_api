RSpec.describe "POST /api/v1/orders", type: :request do
  let!(:product_1) { create(:product, name: "Pizza", price: 10) }
  let!(:product_2) { create(:product, name: "Kebab", price: 20) }

  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:user_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }  

  describe "successfully" do
    before do
      post "/api/v1/orders", params: { product_id: product_1.id }
    end

    it "responds with success message" do
      expect(response_json["message"]).to eq "The product has been added to your order"
    end

    it "responds with 200 status" do
      expect(response.status).to eq 200
    end

    it "responds with order id" do
      expect(response_json["order"]["id"]).to eq Order.last.id
    end

    it "current user has order with pizza in it"
      expect(current_user.orders.first.order_items.first.product.name).to eq "Pizza"
    end
  end
end

# :authenticate_user!
# def create
#   order = Order.create(user: current_user)
#   order.order_items.create(product_id: params[:product_id])
#   render json: { 
#     message: "The product has been added to your order",
#     order: {
#       id: order.id
#     }
#   }
# end