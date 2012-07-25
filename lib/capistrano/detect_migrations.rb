require 'capistrano-deploytags'

module Capistrano
  module DetectMigrations

    def last_git_tag_for(stage)
      `git tag -l #{stage}-[0-9]*`.split(/\n/).last
    end

    def pending_migrations?
      !(`git diff --shortstat #{last_git_tag_for(stage)} #{branch} db/migrate`.strip.empty?)
    end
    
    def show_pending_migrations
      cdt.safe_run 'git', 'diff', '--summary', '--color', last_git_tag_for(stage), branch, 'db/migrate'
    end

    def approved?
      $stdin.gets.strip.downcase == 'y'
    end

    def self.load_into(configuration)
      configuration.load do
        after 'git:prepare_tree', 'git:detect_migrations'

        desc 'check for pending Rails migrations with git'
        namespace :git do
          task :detect_migrations do
            cdt.validate_git_vars
            if cdm.pending_migrations?
              logger.log Logger::IMPORTANT, "Pending migrations!!!"
              cdm.show_pending_migrations
          
              $stdout.puts "Do you want to continue deployment? (Y/N)"
              unless cdm.approved?
                logger.log Logger::IMPORTANT, "Aborting deployment!"
                raise 'aborted deployment'
              end
            end
          end
        end
      end
    end
  end
end

Capistrano.plugin :cdm, Capistrano::DetectMigrations

if Capistrano::Configuration.instance
  Capistrano::DetectMigrations.load_into(Capistrano::Configuration.instance(:must_exist))
end
