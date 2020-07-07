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

    it "responds with right amount of products" do
      expect(response_json["order"]["products"].count).to eq 1
    end

    it "responds with right order total" do
      expect(response_json["order"]["total"]).to eq 10
    end
  end
end

# :authenticate_user!
# def create
#   order = Order.create(user: current_user)
#   order.order_items.create(product_id: params[:product_id])
#   render json: create_json_response(order)
# end

# def create_json_response(order)
#   json = { order: OrderSerializer.new(order) }
#   json.merge!(message: 'The product has been added to your order')
# end