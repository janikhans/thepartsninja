require 'rails_helper'

describe Brand do
  it "has a valid factory" do
    expect(build(:brand)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:brand, name: nil)).to_not be_valid
  end

  it "will correctly sanitize name before saving" do
    brand = create(:brand, :yamaha, name: "  yamaha  ")
    expect(brand.name).to eq "Yamaha"
  end

  # it "will only save a url with correct formatting" do 
    # Work this one out
  # end
end