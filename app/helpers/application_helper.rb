module ApplicationHelper
  ALERT_TYPES = [ :success, :info, :warning, :danger ]

  # This method is based on the implementation in twitter-bootstrap-rails. It
  # has been slightly edited.
  #
  # See https://github.com/seyhunak/twitter-bootstrap-rails/blob/f870d3a3a9223d8e05f29c942826e45bee39337a/app/helpers/bootstrap_flash_helper.rb
  def bootstrap_flash
    messages = flash.flat_map do |type, message|
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger if type == :alert
      type = :danger if type == :error
      next unless ALERT_TYPES.include?(type)

      options = {
        class: "alert fade in alert-#{type}"
      }

      close_button =
        content_tag(:button, "×", type: "button", class: "close", "data-dismiss" => "alert")

      Array(message).flat_map do |msg|
        if msg
          content_tag(:div, close_button + msg, options)
        end
      end
    end

    messages.compact.join("\n").html_safe
  end
end
