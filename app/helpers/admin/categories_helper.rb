module Admin::CategoriesHelper
  def nested_categories(categories)
    categories.map do |category, sub_categories|
      render(category) + content_tag(:div, nested_categories(sub_categories), class: "nested_categories")
    end.join.html_safe
  end

  def category_breadcrumb(category)
    content_tag(:span, class: "category-breadcrumb") do
      category.path.map { |e| e.name }.join(" < ")
    end
  end
end
