Gem::Specification.new do |s|
  s.name        = 'capistrano-detect-migrations'
  s.version     = '0.6.1'
  s.date        = '2012-05-30'
  s.summary     = "Detect pending Rails migrations with Git before you deploy."
  s.description = <<-EOS 
  Capistrano Detect Migrations lets you detect pending Rails migrations before you deploy to any remote hosts. It leverages Git tagging to determine changes that have happened since the last deployment. At deployment time you can choose to continue to deploy or not after being presented with a list of pending migrations.
  EOS
  s.authors     = ["Karl Matthias"]
  s.email       = 'relistan@gmail.com'
  s.files       = Dir.glob("lib/**/*") + %w{ README.md LICENSE }
  s.homepage    = 'http://github.com/mydrive/capistrano-detect-migrations'
  s.add_dependency 'capistrano'
  s.add_dependency 'capistrano-ext'
  s.add_dependency 'capistrano-deploytags'
  s.require_path = 'lib'
end
