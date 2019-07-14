module ApplicationHelper

  def set_title(title = '')
    page_title = "Desired service"
    page_title = "#{title}ー#{page_title}"  unless page_title.empty?    
    provide(:title, page_title)
  end
  
end
