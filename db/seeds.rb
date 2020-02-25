# require 'active_record/fixtures'
# Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "operating_systems")

['shared', Rails.env, ENV['SEED_BUCKET']].uniq.select{|e|e.present?}.each do |env|
  seeds = []

  seeds_path = Rails.root.join('db', 'seeds')
  seeds_env_path = File.join(seeds_path, env)

  common_file = "#{seeds_env_path}.rb"
  seeds << common_file if File.exist? common_file

  if File.directory?(seeds_env_path)
    Dir[File.join(seeds_env_path, '*.rb')].sort.each do |file|
      seeds << file
    end
  end

  seeds.each do |seed|
    name = seed.sub seeds_path.to_s, ''
    name.sub!(/^\/+/, '')
    name.gsub!(/\/+/, ' ')
    name.sub!(/\.rb$/, '')

    if ENV['load'].present?
      next unless name.start_with?(ENV['load'] + '_')
    end

    puts "== #{name}: loading\n"
    start_at = Time.current
    
    load seed
    
    duration = (Time.current - start_at).round(5)
    puts "== #{name}: done (#{duration}s)\n\n"
  end
end
