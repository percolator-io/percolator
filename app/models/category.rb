class Category < ActiveRecord::Base

  acts_as_tree

  def tags=(arg)
    array = case arg
      when String then arg.split(',')
      when Enumerable then arg.to_a
      else raise ArgumentError
    end
    array.sort!
    super array
  end
end
