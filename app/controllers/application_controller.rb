class ApplicationController < ActionController::Base
  protected

  def errors_to_html(obj)
    return unless obj.errors.any?

    error_msg = "<strong>Ошибки (#{obj.errors.count}):</strong><ul class=\"error-notice\">"
    obj.errors.full_messages.each do |msg|
      error_msg += "<li><span class=\"material-icons error-circle\">cancel</span> #{msg}</li>"
    end
    error_msg += '</ul>'

    error_msg
  end
end
