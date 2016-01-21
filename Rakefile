#!/usr/bin/env rake
require 'foodcritic'
require 'kitchen'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Style tests. RuboCop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any']
    }
  end

  desc 'Run extra Foodcritic rulesets'
  task :chef_extra do
    sh 'foodcritic -f any -I foodcritic/* .' if Dir.exist? 'foodcritic'
  end
end

desc 'Run all style checks'
task style: ['style:ruby', 'style:chef', 'style:chef_extra']

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

task default: %w(style spec)
