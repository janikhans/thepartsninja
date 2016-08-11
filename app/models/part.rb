class Part < ActiveRecord::Base
  # TODO column with Ebay ID if it's from the Ebay database.
  # Eventually every part should require a part_number - Maybe
  # asssociated table with part_numbers from various suppliers
  # this part_number is the OEM supplied part_number

  extend FriendlyId
  friendly_id :part_number, use: [:finders]

  validates :product, presence: true
  belongs_to :product

  belongs_to :user
  has_many :fitments, dependent: :destroy
  has_many :oem_vehicles, through: :fitments, source: :vehicle
  has_many :part_traits, dependent: :destroy
  has_many :part_attributes, through: :part_traits, source: :part_attribute
  has_many :compatibles, dependent: :destroy

  accepts_nested_attributes_for :part_traits, reject_if: :all_blank, allow_destroy: true

  def to_label
    "#{product.brand.name} #{product.category.name} #{product.name} #{part_number}"
  end

  def compatible_parts #Finds just the compatible parts to the part being searched
    compatible_parts = []
    self.compatibles.each do |c|
      compatible_parts << c.compatible_part #if c.cached_votes_score >= 0 #if c.discovery.modifications == false
    end
    return compatible_parts
  end

  def find_potentials
    potentials = []

    #First level is what is directly known to be compatible with this part. Distance = 1
    compatibles = self.compatible_parts
    compatibles.uniq!

    #Second level represents the first level of potentials to the original part. Distance = 2
    second_level = next_level(compatibles)
    second_level.reject! { |f| compatibles.include?(f) || f == self }
    potentials += second_level.map{|part| {part: part, score: 0.5}}
    second_level.uniq!

    #Third level is Distance = 3 from the original part
    third_level = next_level(second_level)
    third_level.reject! { |f| compatibles.include?(f) || second_level.include?(f) || f == self}
    potentials += third_level.map{|part| {part: part, score: 0.25}}
    third_level.uniq!

    #Third level is Distance = 4 from the original part
    fourth_level = next_level(third_level)
    fourth_level.reject! { |f| compatibles.include?(f) || second_level.include?(f) || third_level.include?(f) || f == self}
    potentials += fourth_level.map{|part| {part: part, score: 0.1}}

    #Now we need to go through our array and combine the scores of hashes that share the same part
    temp_potentials = Hash.new(0)
    potentials.each do |potential|
      temp_potentials[potential[:part]] += potential[:score]
    end

    #Because this last step changed our format away from the format we need key: value, we're changing it back!
    final = temp_potentials.collect{ |key, value| {part: key, score: value}}

    return final
  end

  private

    def next_level (parent_level) # Finds all parts from the next level down based on their compatibles.
      compatibles = []

      parent_level.each do |p|
        compatibles << p.compatible_parts
      end

      compatibles.flatten!
      return compatibles
    end

end
