LEVELS = %i[major minor patch].freeze

def version
  @version ||= begin
    v = `git describe --always --tags`
    {}.tap do |h|
      s = v.scan(/^v([0-9]+)[.]([0-9]+)[.]([0-9]+)-?([0-9]*)-?([0-9a-z]*)$/)
      h[:major], h[:minor], h[:patch], h[:rev], h[:rev_hash] = s.first if s
    end
  end
end

def increment(level)
  v = version.dup
  v[level] = v[level].to_i + 1

  to_zero = LEVELS[LEVELS.index(level) + 1..LEVELS.size]
  to_zero.each { |z| v[z] = 0 }

  Rake::Task['version:set'].invoke(v[:major], v[:minor], v[:patch])
end

desc 'Display version'
task :version do
  puts "Current version: #{`git describe --always --tags`}"
end

namespace :version do
  LEVELS.each do |l|
    desc "Increment #{l} version"
    task l.to_sym do
      increment(l.to_sym)
    end
  end

  desc 'Set specific major, minor and patch'
  task :set, [:major, :minor, :patch] do |_, args|
    sh "git tag v#{args[:major]}.#{args[:minor]}.#{args[:patch]} && git push --tags"
  end
end
