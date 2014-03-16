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

  def admin?
    false
  end
end
