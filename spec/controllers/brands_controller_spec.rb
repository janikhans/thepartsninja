require 'rails_helper'

describe BrandsController do 

  login_admin

  describe 'POST #create' do 
    context 'with valid attributes' do
      it 'creates the brand' do
        post :create, brand: attributes_for(:brand)
        expect(Brand.count).to eq(1)
      end
    end
  end

end