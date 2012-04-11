require 'capistrano'
require 'capistrano-spec'
require 'capistrano-deploytags'
require 'fileutils'
mypath = File.expand_path(File.dirname(__FILE__))
require File.expand_path(File.join(mypath, '..', 'lib', 'capistrano', 'detect_migrations'))

describe Capistrano::DetectMigrations do
  let(:configuration) { Capistrano::Configuration.new }
  let(:tmpdir) { "/tmp/#{$$}" }
  let(:mypath) { mypath }

  before :each do
    Capistrano::DetectMigrations.load_into(configuration)
  end

  def with_clean_repo(&block)
    FileUtils.rm_rf tmpdir
    FileUtils.mkdir tmpdir
    FileUtils.chdir tmpdir
    raise unless system("/usr/bin/tar xzf #{File.join(mypath, 'fixtures', 'git-fixture.tar.gz')}")
    FileUtils.chdir "#{tmpdir}/git-fixture"
    yield
    FileUtils.rm_rf tmpdir
  end

  def set_branch_and_stage
    configuration.set(:branch, 'master')
    configuration.set(:stage, 'dev')
  end

  context "with a clean git tree" do
    it "raises an error if :stage or :branch are undefined" do
      with_clean_repo do
        lambda { configuration.find_and_execute_task('git:detect_migrations') }.should raise_error('define :branch or :stage')
      end
    end

    it "does not raise an error when run from a clean tree" do
      with_clean_repo do
        set_branch_and_stage
        configuration.cdm.stub(:approved?).and_return(true)
        lambda { configuration.find_and_execute_task('git:detect_migrations') }.should_not raise_error
      end
    end

    it "detects pending migrations" do
      with_clean_repo do
        set_branch_and_stage
        configuration.cdm.should_receive(:approved?).and_return(false)
        lambda { configuration.find_and_execute_task('git:detect_migrations') }.should raise_error('aborted deployment')
      end
    end
  end
end
