module ApplicationHelper
  def title_tag_set(title = '')
    page_title = 'Desired service'
    page_title = "#{title}ー#{page_title}" unless title.empty?
    provide(:title, page_title)
  end

  def check_page(controller_name, action_name)
    controller.controller_name == controller_name && controller.action_name == action_name
  end
end
