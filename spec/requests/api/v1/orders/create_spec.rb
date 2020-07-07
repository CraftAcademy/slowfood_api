RSpec.describe "POST & PUT /api/v1/orders", type: :request do
  let!(:product_1) { create(:product, name: "Pizza", price: 10) }
  let!(:product_2) { create(:product, name: "Kebab", price: 20) }

  before do
    post "/api/v1/orders", params: { product_id: product_1.id }
    order_id = JSON.parse(response.body)["order"]["id"]
    @order = Order.find(order_id)
  end

  describe "POST /api/v1/orders" do
    it "responds with success message" do
      expect(JSON.parse(response.body)["message"]).to eq "The product has been added to your order"
    end

    it "responds with order id" do
      expect(JSON.parse(response.body)["order"]["id"]).to eq @order.id
    end

    it "responds with right amount of products" do
      expect(JSON.parse(response.body)["order"]["products"].count).to eq 1
    end

    it "responds with right order total" do
      expect(JSON.parse(response.body)["order"]["total"]).to eq 10
    end
  end

  describe "PUT /api/v1/orders/:id" do
    before do
      put "/api/v1/orders/#{@order.id}", params: { product_id: product_2.id }
      put "/api/v1/orders/#{@order.id}", params: { product_id: product_2.id }
    end

    it "adds another product to order if request is a PUT and param id of the order is present" do
      expect(@order.order_items.count).to eq 3
    end

    it "responds with order id" do
      expect(JSON.parse(response.body)["order"]["id"]).to eq @order.id
    end

    it "responds with right amount of unique products" do
      expect(JSON.parse(response.body)["order"]["products"].count).to eq 2
    end

    it "responds with right order total" do
      expect(JSON.parse(response.body)["order"]["total"]).to eq 50
    end
  end
end