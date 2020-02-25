class ViewFields
  attr_accessor :user_fields
  attr_accessor :available_fields

  def initialize(fields)
    self.available_fields = []
    self.user_fields = (fields ? JSON.parse(fields) : []).map(&:to_sym)
  end

  def filter(fields, parent = nil)
    append_available_fields fields, parent
    queried_fields = parent.present? ? user_fields[parent] : user_fields
    queried_fields.blank? ? fields : fields & queried_fields
  end

  def visible?(field, parent = nil)
    append_available_fields [field], parent
    queried_fields = parent.present? ? user_fields[parent] : user_fields
    queried_fields.blank? || queried_fields.include?(field.to_sym)
  end

  private

  def append_available_fields(fields, parent = nil)
    fields.each do |field|
      available_fields << parent.present? ? { parent => field } : field
    end
  end
end
