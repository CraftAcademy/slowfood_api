RSpec.describe "PUT /api/v1/orders/:id", type: :request do
  let!(:product_1) { create(:product, name: "Pizza", price: 10) }
  let!(:product_2) { create(:product, name: "Kebab", price: 20) }

  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:user_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }  

  let(:order) { create(:order, user: user) }
  let(:order_item) { create(:order_item, order: order, product: product_1 }
  
  describe "succesfully" do
    before do
      put "/api/v1/orders/#{order.id}", params: { product_id: product_2.id }
    end

    it "responds with success message" do
      expect(response_json["message"]).to eq "The product has been added to your order"
    end

    it "responds with 200 status" do
      expect(response.status).to eq 200
    end

    it "responds with right amount of unique products" do
      expect(response_json["order"]["products"].count).to eq 2
    end

    it "responds with right order total" do
      expect(response_json["order"]["total"]).to eq 30
    end

    it "responds with order id" do
      expect(response_json["order"]["id"]).to eq order.id
    end
  end
end

# def update
#   order = current_user.orders.find(params[:id]).first
#   product = Product.find(params[:product_id])
#   order.order_items.create(product: product)
#   render json: create_json_response(order)
# end