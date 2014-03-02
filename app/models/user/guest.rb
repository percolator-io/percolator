class User::Guest
  def id
    -1
  end

  def selected_categories
    Category.none
  end

  def excluded_categories
    Category.none
  end

  def guest?
    true
  end

  User.available_resources.values.each do |resource|
    define_method "has_access_to_#{resource}?" do
      false
    end
  end
end
