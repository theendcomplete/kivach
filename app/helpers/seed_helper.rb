module SeedHelper
  module_function

  def meta_execute(path, func)
    func.call JSON.parse(File.read(File.join(path, 'metadata.json')), symbolize_names: true), path
  end

  def meta_execute_all(path, func)
    services_path = Rails.root.join(path)
    Dir[File.join services_path, '/*'].map do |file_path|
      meta_execute file_path, func if File.directory? file_path
    end
  end
end
