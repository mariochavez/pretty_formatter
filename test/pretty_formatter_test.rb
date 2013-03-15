require 'test_helper'

class PrettyFormatterTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, PrettyFormatter
  end

  test 'add color green to DEBUG severity' do
    PrettyFormatter.verbose = false
    formatter = PrettyFormatter.formatter

    assert_equal formatter.call('DEBUG', DateTime.now, 'Test', 'Testing...'),
      "\e[32mDEBUG\e[0m Testing...\n"
  end

  test 'add color white to INFO severity' do
    PrettyFormatter.verbose = false
    formatter = PrettyFormatter.formatter

    assert_equal formatter.call('INFO', DateTime.now, 'Test', 'Testing...'),
      "\e[37mINFO\e[0m Testing...\n"
  end

  test 'add color yellow to WARN severity' do
    PrettyFormatter.verbose = false
    formatter = PrettyFormatter.formatter

    assert_equal formatter.call('WARN', DateTime.now, 'Test', 'Testing...'),
      "\e[33mWARN\e[0m Testing...\n"
  end

  test 'add color red to ERROR severity' do
    PrettyFormatter.verbose = false
    formatter = PrettyFormatter.formatter

    assert_equal formatter.call('ERROR', DateTime.now, 'Test', 'Testing...'),
      "\e[31mERROR\e[0m Testing...\n"
  end

  test 'add color red to FATAL severity' do
    PrettyFormatter.verbose = false
    formatter = PrettyFormatter.formatter

    assert_equal formatter.call('FATAL', DateTime.now, 'Test', 'Testing...'),
      "\e[31mFATAL\e[0m Testing...\n"
  end

  test 'add color blue to any other severity' do
    PrettyFormatter.verbose = false
    formatter = PrettyFormatter.formatter

    assert_equal formatter.call('UNKNOWN', DateTime.now, 'Test', 'Testing...'),
      "\e[34mUNKNOWN\e[0m Testing...\n"
  end

  test 'verbose mode add host and timestamp to log' do
    PrettyFormatter.verbose = true
    formatter = PrettyFormatter.formatter

    log_line = formatter.call('INFO', DateTime.now, 'Test', 'Testing...')

    assert log_line.match(/\d{4}(-\d{2}){2}T(\d{2}:){2}\d{2}\./).present?
    assert log_line.match(/(\S)+\.(\d)+\s{2}/).present?
    assert log_line.include?("\e[37mINFO\e[0m Testing...\n")
  end

  test 'verbose mode include custom string in log' do
    PrettyFormatter.custom = 'TEST'
    PrettyFormatter.verbose = true
    formatter = PrettyFormatter.formatter

    log_line = formatter.call('INFO', DateTime.now, 'Test', 'Testing...')
    assert log_line.start_with?('TEST')
  end
end
