module ApplicationHelper
  def format_url_for_pagination url, page_param, page_number
    url.split('?')[0] + "?#{page_param}=#{page_number}"
  end
end
