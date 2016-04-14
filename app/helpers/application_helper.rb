module ApplicationHelper
  def display_key(key = '')
    if(key == "error" || key == "alert")
      "danger"
    elsif (key == "notice")
      "success";
    else
      key;
    end
  end
end

module Roles
  Teacher = "Teacher"
  Student = "Student"
end