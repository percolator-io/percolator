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
end
