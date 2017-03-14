module SearchPaginationHelper
  def paginate_search(search_record, options = {})

    if search_record.current_page <= 2
      page_start = 1
    else
      page_start = search_record.current_page - 2
    end

    page_end = search_record.current_page + 2

    nav = '<ul class="search-pagination pagination pull-right">'
    nav += first_page(search_record) unless search_record.current_page == 1
    nav += previous_page(search_record) unless search_record.current_page == 1
    (page_start..page_end).to_a.each do |page|
      next if page > search_record.total_pages
      if search_record.current_page == page
        nav += content_tag(:li, content_tag(:span, page), class: "active")
      else
        nav += content_tag(:li, link_to(page,find_path(search_record, page: page), remote: true))
      end
    end
    nav += next_page(search_record) unless search_record.current_page == search_record.total_pages
    nav += last_page(search_record) unless search_record.current_page == search_record.total_pages
    nav += "</ul>"
    nav.html_safe
  end

  private

  def previous_page(search_record)
    content_tag(:li, link_to(icon(:angle_left), find_path(search_record, page: search_record.current_page - 1), remote: true))
  end

  def next_page(search_record)
    content_tag(:li, link_to(icon(:angle_right), find_path(search_record, page: search_record.current_page + 1), remote: true))
  end

  def first_page(search_record)
    content_tag(:li, link_to(icon(:angle_double_left), find_path(search_record, page: 1), remote: true))
  end

  def last_page(search_record)
    content_tag(:li, link_to(icon(:angle_double_right), find_path(search_record, page: search_record.total_pages), remote: true))
  end
end
