class EbayPartImporter < CSVParty
  column :epid, header: 'ePID', as: :integer
  column :product_brand, header: 'Part Brand', as: :pretty_string
  column :product_name, header: 'Part Type', as: :pretty_string
  column :part_number, header: 'Part number', as: :string
  column :reserved_title, header: 'RESERVED_PRODUCT_TITLE', as: :string
  column :category_id, header: 'Category ID'
  column :category_breadcrumb, header: 'Category Breadcrumb', as: :string

  import do |row|
    next if Part.find_by(epid: row.epid)

    begin
      ActiveRecord::Base.transaction do
        categories = row.category_breadcrumb.split(':')
        root_category = categories[2]
        category = categories[3]
        subcategory = categories[4]

        product_form = EbayProductForm.new(
          brand: row.product_brand,
          product_name: row.product_name,
          root_category: root_category,
          category: category,
          subcategory: subcategory
        )

        unless product_form.save
          raise ActiveModel::ValidationError, product_form
        end

        product = product_form.product
        note = row.reserved_title.split(',')[1]

        part = product.parts
                      .where('lower(part_number) = ?', row.part_number.downcase)
                      .first_or_initialize(part_number: row.part_number)
        part.epid = row.epid
        part.note = note
        part.save!

        if note.present?
          attribute_list = note.split(' - ').map(&:strip)
          attributes = PartAttribute.specific_attributes
                                    .where(name: attribute_list)
          attributes.each do |attribute|
            attribute.part_attributions.where(part: part).first_or_create
          end
        end
      end
    rescue ActiveRecord::RecordInvalid, ActiveModel::ValidationError => e
      EbayPartImportError.create(row: row.csv_string, import_errors: e.message)
    end
  end

  error do |error, line_number|
    row = IO.readlines(@csv.path)[line_number]
    EbayPartImportError.create(row: row, import_errors: error.message)
  end

  def pretty_string_parser(value)
    return if value.blank?
    value = value.strip
    value[0].upcase + value[1..-1]
  end
end
