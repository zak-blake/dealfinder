module ApplicationHelper
  def small_box_classes
    "col-lg-4 col-lg-offset-4 col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-12"
  end

  def hidden_ham?
    if (controller_name == "sessions" && action_name == "new") ||
      (controller_name == "passwords" && action_name == "new") ||
      (controller_name == "registrations" && action_name == "new")
        return true
      end
  end

  def wide_page?
    if (controller_name == "events" && action_name == "index") ||
      (controller_name == "users" && action_name == "index")
        return false
    end
  end
end
