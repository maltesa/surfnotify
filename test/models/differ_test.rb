require 'json'
require 'test_helper'

# Tests the differ class for correctness
class DifferTest < ActiveSupport::TestCase
  def setup
    # init sample data
    @new_d = sample_data
    @old_d = @new_d.deep_dup
  end

  test 'differ datatypes' do
    diff = Diff.new(new: @new_d, old: @old_d)
    insert_new!(@new_d, :future)
    insert_new!(@old_d, :future)
    alter_random!(@new_d)
    assert_equal Hash, diff.new_matches.class
    assert_equal Hash, diff.changed_matches.class
    assert_equal Hash, diff.passed_matches.class
  end

  test 'only_new_data' do
    insert_new!(@new_d, :future)
    diff = Diff.new(new: @new_d, old: @old_d)
    assert diff.matches?
    assert diff.new_matches?
    assert_not diff.changed_matches?
    assert_not diff.passed_matches?
  end

  test 'only_changed_data' do
    alter_random!(@new_d)
    diff = Diff.new(new: @new_d, old: @old_d)
    assert diff.matches?
    assert diff.changed_matches?
    assert_not diff.new_matches?
    assert_not diff.passed_matches?
  end

  test 'new_and_changed_data' do
    insert_new!(@new_d, :future)
    alter_random!(@new_d)
    diff = Diff.new(new: @new_d, old: @old_d)
    assert diff.matches?
    assert diff.new_matches?
    assert diff.changed_matches?
    assert_not diff.passed_matches?
  end

  test 'passed_matches' do
    # old data contains a match which is missing in new data
    insert_new!(@old_d, :future)
    diff = Diff.new(new: @new_d, old: @old_d)
    assert_not diff.matches?
    assert_not diff.new_matches?
    assert_not diff.changed_matches?
    assert diff.passed_matches?, @old_d.inspect + @new_d.inspect
  end

  test 'unchanged_data' do
    diff = Diff.new(new: @new_d, old: @old_d)
    assert_not diff.matches?
    assert_not diff.new_matches?
    assert_not diff.changed_matches?
    assert_not diff.passed_matches?
  end

  def insert_new!(data, t)
    _, fc = data.first.dup
    new_ts = case t
             when :future
               Time.now.to_i + (rand * 60 * 60 * 7).to_i
             when :past
               Time.now.to_i - (rand * 60 * 60 * 7).to_i
             else
               raise 'unkown time'
             end
    data[new_ts.to_s] = fc
    data
  end

  def alter_random!(data)
    key = data.keys.sample
    data[key]['swell_size'] = data[key]['swell_size'].map { |v| v + 3 }
    data
  end

  def sample_data
    # refresh timestamps to be in the future
    data = {}
    new_ts = Time.now
    new_ts = (new_ts - new_ts.min.minutes - new_ts.sec.seconds).to_i
    ff = JSON.parse(SAMPLE)
    ff.each do |_, v|
      data[new_ts.to_s] = v
      new_ts += 3.hours.to_i
    end
    data
  end

  SAMPLE = '{"1515801600":{"new":true,"wind_dir":185.0,"swell_dir":[276.26,349.0],"swell_size":[3.0,0.4],"wind_speed":42.0,"probability":100.0,"swell_period":[14.0,9.0],"weather_temp":14.0,"weather_descr":"Brief Showers"},"1515812400":{"new":true,"wind_dir":193.0,"swell_dir":[279.52,254.0],"swell_size":[3.5,0.3],"wind_speed":30.0,"probability":100.0,"swell_period":[13.0,14.0],"weather_temp":14.0,"weather_descr":"Rain"}}'
end
