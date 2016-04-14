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
  Danlang =1
  Masoi=2
  Daotac =3
  Tientri =4
  Kegayroi=5
end