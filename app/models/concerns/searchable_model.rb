module SearchableModel
  extend ActiveSupport::Concern

  included do
    enum search_type: [:known, :potential]

    belongs_to :vehicle
    validates :vehicle, presence: true

    validates :category_name, presence: true

    belongs_to :category
    belongs_to :user
    belongs_to :fitment_note

    has_one :search_record, as: :searchable
  end

  def current_page
    @current_page ||= 1
  end

  def total_pages
    pages = grouped_count.to_f / limit
    pages.ceil
  end

  def can_advance_page?
    unless successful?
      raise ArgumentError, "search must be processed first"
    end
    current_page < total_pages
  end

  def next_page
    if can_advance_page?
      current_page + 1
    end
  end

  # def type
  #   @type ||= "compatibilities"
  # end

  private

  # def type=(value)
  #   @type = value
  # end

  def threshold=(value)
    unless (value.is_a? Integer) && value > 0
      raise ArgumentError, "expects a positive integer as threshold"
    end
    @threshold = value
  end

  def threshold
    @threshold ||= 20
  end

  def limit=(value)
    unless (value.is_a? Integer) && value > 0
      raise ArgumentError, "expects a positive integer as limit"
    end
    @limit = value
  end

  def limit
    @limit ||= 10
  end

  def current_page=(value)
    value = value.to_i
    unless value > 0
      raise ArgumentError, "expects a positive integer as page number"
    end
    @current_page = value
  end

  def offset
    current_page * limit - limit
  end
end
