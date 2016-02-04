require 'rails_helper'
Warden.test_mode!

describe BrandsController do 

  describe 'POST #create' do 

    login_admin

    context 'with valid attributes' do
      it 'creates the brand' do
        post :create, brand: attributes_for(:brand)
        expect(Brand.count).to eq(1)
      end
    end
  end

end