class User::Guest
  def id
    -1
  end

  def selected_categories_with_descendants
    []
  end

  def excluded_categories_with_descendants
    []
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
