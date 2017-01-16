 # override of default devise error messages

module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    puts resource.errors.full_messages.join("\n")

    flash[:alert] = resource.errors.full_messages.join("<br />").html_safe

    nil
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end
