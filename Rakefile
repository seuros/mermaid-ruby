# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'

Minitest::TestTask.create
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task default: :test
