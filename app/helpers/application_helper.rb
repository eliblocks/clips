module ApplicationHelper

  def cl_image_url(video)
    "#{Video.cl_base_url}/#{video.image_id}"
  end

  def youtube_time(seconds)

    hours = 0
    minutes = 0
    while seconds >= 3600
      hours += 1
      seconds -= 3600
    end
    while seconds >= 60
      minutes += 1
      seconds -= 60
    end
    str = ( hours > 0 ? "#{hours}:#{minutes.to_s.rjust(2,'0')}:" : "#{minutes}:" ) + seconds.to_s.rjust(2,'0')
    return str
  end

  def nav_link(text, path)
    current_page?(path) ? active_status = 'active' : active_status = ''
    link_to(text, path, class: "nav-link #{active_status}")
  end

  def full_title(page_title = '')
    base_title = "Browzable"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def description_meta_tag(description = '')
    if description == ''
      return nil
    end
    content_tag(:meta, "", name:'description', content: description)
  end

  def popover(video)
    video.description.empty? ? '' : popover_content(video)
  end

  def popover_content(video)
    <<~HEREDOC
      <h2 class="popover-title">#{video.title}</h2>
      <span>R | #{video.runtime} | #{video.language}
      <hr>
      <p class="popover-description">#{video.description}</p>
    HEREDOC
  end
end
