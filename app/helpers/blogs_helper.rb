# frozen_string_literal: true

module BlogsHelper
  def format_content(blog)
    splited_contents = blog.content.split("\n")
    safe_join(splited_contents, tag.br)
  end
end
