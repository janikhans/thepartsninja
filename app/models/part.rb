class Part < ActiveRecord::Base
  extend FriendlyId
  friendly_id :part_number, use: [:finders]

  validates :product, presence: true

  include CompatiblesFinder

  belongs_to :product
  belongs_to :user
  has_many :fitments, dependent: :destroy
  has_many :oem_vehicles, through: :fitments, source: :vehicle

  has_many :compatibles

  has_many :known_compatibles,               -> {where backwards: true}, class_name: "Compatible", foreign_key: "part_id"
  has_many :backwards_compatibles,           -> {where backwards: true}, class_name: "Compatible", foreign_key: "compatible_part_id"
  has_many :known_not_backwards_compatibles, -> {where backwards: false}, class_name: "Compatible", foreign_key: "part_id"
  has_many :potential_compatibles,           -> {where backwards: false}, class_name: "Compatible", foreign_key: "compatible_part_id"

  def compatible_parts #Finds just the compatible parts to the fitment being searched
    compatible_parts = []
    self.compats.each do |c|
      compatible_parts << c.compatible_part #if c.discovery.modifications == false
    end
    return compatible_parts
  end

  def next_level (level) # Finds all parts from the next level down based on their compatibles.
    parent_level = level
    compatibles = []

    parent_level.each do |p|
      compatibles << p.compatible_parts
    end

    compatibles.flatten!
    return compatibles
  end

  def find_potentials
    potentials = []

    #First level is what is directly known to be compatible with this part. Distance = 1
    compatibles = self.compatible_parts

    ## Second level represents the first level of potentials to the original part. Distance = 2
    second_level = next_level(compatibles)
    second_level.reject! { |f| compatibles.include?(f) || f == self }
    potentials << second_level

    #Third level is Distance = 3 from the original part
    third_level = next_level(second_level)
    third_level.reject! { |f| compatibles.include?(f) || second_level.include?(f) || f == self}
    potentials << third_level.uniq

    #Third level is Distance = 4 from the original part
    fourth_level = next_level(third_level)
    fourth_level.reject! { |f| compatibles.include?(f) || second_level.include?(f) || third_level.include?(f) || f == self}
    potentials << fourth_level.uniq

    #Fifth Level but I don't know if we'll use this yet.
    # fifth_level = next_level(fourth_level)
    # fifth_level.reject! { |f| compatibles.include?(f) || second_level.include?(f) || third_level.include?(f) || fourth_level.include?(f) || f == self}
    # potentials << fifth_level.uniq

    potentials.flatten!
    return potentials
  end


  def array_weighted_level (level, weight)
    parent_level = level
    parts = []

    parent_level.each do |p|
      parts << p.compatible_parts
    end
    parts.flatten!

    compatibles = parts.map{|part| {part: part, score: weight}}

    return compatibles
  end


  def hash_weighted_level (level, weight)
    parent_level = level
    parent_parts = []
    parts = []

    parent_level.each do |p|
      parent_parts << p[:part]
    end

    parent_parts.each do |p|
      parts << p.compatible_parts
    end
    parts.flatten!

    compatibles = parts.map{|part| {part: part, score: weight}}

    return compatibles
  end

  def find_potentials_with_weight
    potentials = []

    compatibles = self.compatible_parts

    second_level = array_weighted_level(compatibles, 0.5)
    second_level.reject! { |f| compatibles.include?(f[:part]) || f[:part] == self }
    potentials << second_level

    #Third level is Distance = 3 from the original part
    third_level = hash_weighted_level(second_level, 0.25)
    third_level.reject! { |f| compatibles.include?(f[:part]) || second_level.include?(f[:part]) || f[:part] == self}
    potentials << third_level

    #Third level is Distance = 4 from the original part
    fourth_level = hash_weighted_level(third_level, 0.1)
    fourth_level.reject! { |f| compatibles.include?(f[:part]) || second_level.include?(f[:part]) || third_level.include?(f[:part]) || f[:part] == self}
    potentials << fourth_level

    return potentials.flatten!
  end

end
