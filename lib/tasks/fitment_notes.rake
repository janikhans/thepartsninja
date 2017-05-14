namespace :fitment_notes do
  desc 'Creates FitmentNotations from existing PartAttributes'
  task :from_part_attribute, [:part_attribute_name, :fitment_note_name] => [:environment] do |_, args|
    start_notations = FitmentNotation.count

    part_attribute = PartAttribute.specific_attributes.find_by(name: args[:part_attribute_name])
    fitment_note = FitmentNote.individual_notes.find_by(name: args[:fitment_note_name])
    abort "Could not find FitmentNote with name: #{args[:fitment_note_name]}" unless fitment_note.present?
    abort "PartAttribute and FitmentNote must match" unless part_attribute.name == fitment_note.name

    fitments = Fitment.eager_load(:fitment_notes, part: :part_attributes)
                      .where('part_attributes.id = ?', part_attribute.id)
                      .where('fitment_notes.id IS NULL OR fitment_notes.id != ?', fitment_note.id)
                      .distinct

    fitments.each do |fitment|
      fitment.fitment_notations.create(fitment_note: fitment_note)
    end

    finish_notations = FitmentNotation.count

    puts "Created #{finish_notations - start_notations} new FitmentNotations"
  end

  desc 'Create FitmentNotations from existing Products'
  task :from_products, [:product_ids, :fitment_note_name] => [:environment] do |_, args|
    start_notations = FitmentNotation.count

    fitment_note = FitmentNote.individual_notes.find_by(name: args[:fitment_note_name])
    abort "Could not find FitmentNote with name: #{args[:fitment_note_name]}" unless fitment_note.present?

    product_ids = args[:product_ids].split(' ').map(&:to_i)
    products = Product.find(product_ids)
    products.select! { |p| p.name.downcase.include?(fitment_note.name.downcase) }

    fitments = Fitment.eager_load(:fitment_notes, part: :product)
                      .where('products.id IN (?)', products.pluck(:id))
                      .where('fitment_notes.id IS NULL OR fitment_notes.id != ?', fitment_note.id)
                      .distinct

    fitments.each do |fitment|
      fitment.fitment_notations.create(fitment_note: fitment_note)
    end

    finish_notations = FitmentNotation.count

    puts "Created #{finish_notations - start_notations} new FitmentNotations"
  end

  desc 'Create FitmentNotations from Fitment.note'
  task :from_fitments, [:fitment_note_name] => [:environment] do |_, args|
    start_notations = FitmentNotation.count

    fitment_note = FitmentNote.individual_notes.find_by(name: args[:fitment_note_name])
    abort "Could not find FitmentNote with name: #{args[:fitment_note_name]}" unless fitment_note.present?

    fitments = Fitment.eager_load(:fitment_notes)
                      .where("note like ? OR note like ? OR note like ?", "%; #{fitment_note.name}", "#{fitment_note.name}", "#{fitment_note.name};%")
                      .where('fitment_notes.id IS NULL OR fitment_notes.id != ?', fitment_note.id)
                      .distinct

    fitments.each do |fitment|
      fitment.fitment_notations.create(fitment_note: fitment_note)
    end

    finish_notations = FitmentNotation.count

    puts "Created #{finish_notations - start_notations} new FitmentNotations"
  end
end
