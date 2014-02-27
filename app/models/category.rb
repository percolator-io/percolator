class Category < ActiveRecord::Base
  validates :name, presence: true
  acts_as_tree order: 'name'

  def keywords=(arg)
    array = case arg
      when String then arg.split(',')
      when Enumerable then arg.to_a
      else raise ArgumentError
    end
    array.sort!
    array.uniq!
    super array
  end
end
