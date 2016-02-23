class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  before_action :authenticate_user!#, except: [:index, :show]

  def index
    @products = Product.order("name ASC").group_by{|u| u.brand }
  end

  def show
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

end
