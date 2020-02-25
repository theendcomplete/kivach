class Setting < ApplicationRecord
  validates :key, uniqueness: true

  def self.get(keys:)
    Setting.where(key: keys).map do |v|
      case v.datatype.to_sym
      when :number
        v.value = v.value.to_i
      when :string
        v.value = v.value.to_s
      end
      [v.key.to_sym, v.value]
    end.to_h
  end
end
