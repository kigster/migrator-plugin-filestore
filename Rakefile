# frozen_string_literal: true
ENV["RUBYOPT"] = "-W0"

require "colored2"
require "bundler/gem_tasks"

require_relative "config/application"
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Rails.application.load_tasks

require "rspec/core/rake_task"
require "rubocop/rake_task"
require "active_record/tasks/database_tasks"

def shell(*args)
  puts "running: #{args.join(" ")}"
  system(args.join(" "))
end

task :clean do
  shell("rm -rf pkg/ tmp/ coverage/ doc/ ")
end

task gem: [:build] do
  shell("gem install pkg/*")
end

task permissions: [:clean] do
  shell("chmod -v o+r,g+r * */* */*/* */*/*/* */*/*/*/* */*/*/*/*/*")
  shell("find . -type d -exec chmod o+x,g+x {} \\;")
end

task build: :permissions

RSpec::Core::RakeTask.new(:rspec)
RuboCop::RakeTask.new(:rubocop)

task default: %i[rspec rubocop]
