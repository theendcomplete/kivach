module ViewHelper
  module_function

  def render(template, params)
    view_path = Rails.root.join('app', 'views').join(template + '.erb')
    view = File.read(view_path)
    view_model = ViewModel.new(params)
    ERB.new(view).result(view_model.bind)
  end
end

class ViewModel
  MAX_NESTING_LEVEL = 2
  def initialize(hash = {}, level = 1)
    hash.each do |key, value|
      singleton_class.send(:define_method, key) do
        if value.is_a?(Hash) && level < MAX_NESTING_LEVEL
          ViewModel.new(value, level + 1)
        else
          value
        end
      end
    end
  end

  def bind
    binding
  end
end
