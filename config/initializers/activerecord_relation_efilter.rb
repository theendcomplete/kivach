class ActiveRecord::Relation
  def efilter(filter)
    where(ExtFilter.new(self, filter).to_s)
  end
end
