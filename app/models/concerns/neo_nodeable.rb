module NeoNodeable
  extend ActiveSupport::Concern

  included do
    # after_update :update_neo_node
  end

  def neo_node
    klass = "Neo" + self.class.name
    neo_klass = klass.constantize
    neo_klass.find(id)
  end

  def update_neo_node
    neo_node.update(attributes.except("created_at", "updated_at"))
  end
end
