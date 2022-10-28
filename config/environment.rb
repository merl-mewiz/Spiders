# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  result = Nokogiri::HTML.fragment(html_tag)

  result.css('input').each do |item|
    item.add_class('is-invalid')
  end

  result.to_s.html_safe
end
