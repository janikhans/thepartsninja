# common shared methods/associations for search model types
module SearchableModel
  extend ActiveSupport::Concern

  included do
    attr_accessor :compatible_results, :potential_results, :eager_load
    acts_as_hashids

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
    raise ArgumentError, 'search must be processed first' unless results.any?
    current_page < total_pages
  end

  def next_page
    current_page + 1 if can_advance_page?
  end

  def successful?
    if persisted?
      results_count.present?
    else
      results.present?
    end
  end

  def results
    compatible_results || potential_results
  end

  private

  def find_results
    if search_type == 'potential'
      self.potential_results = find_potentials
    else
      self.compatible_results = find_compatibilities
    end
  end

  def threshold=(value)
    unless (value.is_a? Integer) && value.positive?
      raise ArgumentError, 'expects a positive integer as threshold'
    end
    @threshold = value
  end

  def threshold
    @threshold ||= 1
  end

  def limit=(value)
    unless (value.is_a? Integer) && value.positive?
      raise ArgumentError, 'expects a positive integer as limit'
    end
    @limit = value
  end

  def limit
    @limit ||= 10
  end

  def current_page=(value)
    value = value.to_i
    unless value.positive?
      raise ArgumentError, 'expects a positive integer as page number'
    end
    @current_page = value
  end

  def offset
    current_page * limit - limit
  end
end
