module SearchPaginationHelper
  def paginate_search(search_record, options = {})
    return if search_record.total_pages == 1
    if search_record.is_a? CheckSearch
      var_path = :check_path
    elsif search_record.is_a? CompatibilitySearch
      var_path = :find_path
    end

    if search_record.current_page <= 2
      page_start = 1
    else
      page_start = search_record.current_page - 1
    end

    page_end = search_record.current_page + 1

    nav = '<ul class="pagination">'
    nav += first_page(search_record, var_path) unless search_record.current_page == 1
    nav += previous_page(search_record, var_path) unless search_record.current_page == 1
    (page_start..page_end).to_a.each do |page|
      next if page > search_record.total_pages
      if search_record.current_page == page
        nav += content_tag(:li, content_tag(:span, page), class: "active")
      else
        nav += content_tag(:li, link_to(page, send(var_path, search_record, page: page), remote: true))
      end
    end
    nav += next_page(search_record, var_path) unless search_record.current_page == search_record.total_pages
    nav += last_page(search_record, var_path) unless search_record.current_page == search_record.total_pages
    nav += "</ul>"
    nav.html_safe
  end

  def pager(search_record)
    return if search_record.total_pages == 1
    if search_record.is_a? CheckSearch
      var_path = :check_path
    elsif search_record.is_a? CompatibilitySearch
      var_path = :find_path
    end
    nav = '<ul class="pager">'
    nav += content_tag(:li, link_to(icon(:arrow_left) + " Previous", send(var_path, search_record, page: search_record.current_page - 1), remote: true)) unless search_record.current_page == 1
    nav += content_tag(:li, link_to("Next #{icon(:arrow_right)}".html_safe, send(var_path, search_record, page: search_record.current_page + 1 ), remote: true)) unless search_record.current_page == search_record.total_pages
    nav += "</ul>"
    nav.html_safe
  end

  private

  def previous_page(search_record, path)
    content_tag(:li, link_to(icon(:angle_left), send(path, search_record, page: search_record.current_page - 1), remote: true))
  end

  def next_page(search_record, path)
    content_tag(:li, link_to(icon(:angle_right), send(path, search_record, page: search_record.current_page + 1), remote: true))
  end

  def first_page(search_record, path)
    content_tag(:li, link_to(icon(:angle_double_left), send(path, search_record, page: 1), remote: true))
  end

  def last_page(search_record, path)
    content_tag(:li, link_to(icon(:angle_double_right), send(path, search_record, page: search_record.total_pages), remote: true))
  end
end
