module CompatiblesFinder

  def compats
    compatibles = []
    backwards_compatibles = []

    self.backwards_compatibles.each do |b|
      b.part, b.compatible_part = b.compatible_part, b.part
      backwards_compatibles << b
    end

    compatibles << self.known_not_backwards_compatibles
    compatibles << self.known_compatibles
    compatibles << backwards_compatibles

    compatibles.flatten!
    # compatibles.uniq{ |c| c.discovery_id}

    self.reload #<---- This SOB! So much headache...
    return compatibles
  end

end