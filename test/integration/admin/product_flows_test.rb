require 'test_helper'

class Admin::ProductFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_products_path

    assert has_text? "Products"
  end

  # TODO Product form needs to have associations setup
  # test "should create new product" do
  #   brand = brands(:yamaha)
  #   category = categories(:motorcycle_parts)
  #   visit admin_products_path
  #   product_name = "Test Product"
  #   product_description = "Test product description"
  #
  #   fill_in "Product Name", with: product_name
  #   select brand.name, from: "Brand"
  #   select category.name, from: "Category"
  #
  #   click_on "Create Product"
  #
  #   assert has_text? product_name
  # end

  test "should navigate to a products page" do
    product = products(:wheel)
    visit admin_products_path

    within "#product_#{product.id}" do
      click_on "View"
    end

    assert has_text? product.name
  end

  # test "should show errors on new product" do
  #   # currently not setup correctly
  # end

  test "should edit product" do
    product = products(:wheel)
    visit edit_admin_product_path(product)
  end
end
