module ApplicationHelper
  def title_tag_set(title = '')
    page_title = 'Desired service'
    page_title = "#{title}ー#{page_title}" unless title.empty?
    provide(:title, page_title)
  end

  def submit_button_name
    if controller.action_name == 'new'
      "作成"
    else
      "更新"
    end
  end
end
