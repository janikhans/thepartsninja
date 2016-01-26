module CompatiblesFinder

  def compats
    compatibles = []
    b_compatibles = []
    k_not_b_compatibles = []

    self.backwards_compatibles.each do |b|
      b.fitment, b.compatible_fitment = b.compatible_fitment, b.fitment
      b_compatibles << b
    end

    self.known_not_backwards_compatibles.each do |b|
      b.fitment, b.compatible_fitment = b.compatible_fitment, b.fitment
      k_not_b_compatibles << b
    end

    compatibles << k_not_b_compatibles
    compatibles << self.known_compatibles
    compatibles << b_compatibles

    compatibles.flatten!
    # compatibles.uniq{ |c| c.discovery_id}

    return compatibles
  end

end