require 'json'
require 'test_helper'

# Tests the differ class for correctness
class DifferTest < ActiveSupport::TestCase
  def setup
    # init sample data
    @new_d = sample_data
    @old_d = sample_data
  end

  test "only_new_data" do
    insert_new!(@new_d, :future)
    diff = Diff.new(new: @new_d, old: @old_d)
    assert diff.matches?
    assert diff.new_matches?
    assert_not diff.changed_matches?
    assert_not diff.passed_matches?
  end

  test "only_changed_data" do
    alter_random!(@new_d)
    diff = Diff.new(new: @new_d, old: @old_d)
    assert diff.matches?
    assert diff.changed_matches?
    assert_not diff.new_matches?
    assert_not diff.passed_matches?
  end

  test "new_and_changed_data" do
    insert_new!(@new_d, :future)
    alter_random!(@new_d)
    diff = Diff.new(new: @new_d, old: @old_d)
    assert diff.matches?
    assert diff.new_matches?
    assert diff.changed_matches?
    assert_not diff.passed_matches?
  end

  test "passed_matches" do
    # old data contains a match which is missing in new data
    insert_new!(@old_d, :past)
    diff = Diff.new(new: @new_d, old: @old_d)
    assert_not diff.matches?
    assert_not diff.new_matches?
    assert_not diff.changed_matches?
    assert_not diff.passed_matches?
  end

  test "unchanged_data" do
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

  SAMPLE = '{"1515801600":{"new":true,"wind_dir":185.0,"swell_dir":[276.26,349.0],"swell_size":[3.0,0.4],"wind_speed":42.0,"probability":100.0,"swell_period":[14.0,9.0],"weather_temp":14.0,"weather_descr":"Brief Showers"},"1515812400":{"new":true,"wind_dir":193.0,"swell_dir":[279.52,254.0],"swell_size":[3.5,0.3],"wind_speed":30.0,"probability":100.0,"swell_period":[13.0,14.0],"weather_temp":14.0,"weather_descr":"Rain"},"1515823200":{"new":true,"wind_dir":321.0,"swell_dir":[283.79,254.0],"swell_size":[3.5,0.4],"wind_speed":33.0,"probability":100.0,"swell_period":[13.0,13.0],"weather_temp":15.0,"weather_descr":"Light Showers Possible"},"1515834000":{"new":true,"wind_dir":311.0,"swell_dir":[286.77,251.0],"swell_size":[3.5,0.4],"wind_speed":34.0,"probability":100.0,"swell_period":[13.0,14.0],"weather_temp":14.0,"weather_descr":"Brief Showers Possible"},"1515844800":{"new":true,"wind_dir":299.0,"swell_dir":[288.43,255.0],"swell_size":[3.5,0.4],"wind_speed":33.0,"probability":100.0,"swell_period":[13.0,13.0],"weather_temp":14.0,"weather_descr":"Brief Showers Possible"},"1515855600":{"new":true,"wind_dir":293.0,"swell_dir":[288.6],"swell_size":[3.6],"wind_speed":34.0,"probability":100.0,"swell_period":[13.0],"weather_temp":14.0,"weather_descr":"Brief Showers Possible"},"1515866400":{"new":true,"wind_dir":295.0,"swell_dir":[289.43,281.0],"swell_size":[3.7,1.0],"wind_speed":32.0,"probability":100.0,"swell_period":[13.0,16.0],"weather_temp":13.0,"weather_descr":"Brief Showers Possible"},"1515877200":{"new":true,"wind_dir":303.0,"swell_dir":[289.12],"swell_size":[3.9],"wind_speed":29.0,"probability":100.0,"swell_period":[15.0],"weather_temp":13.0,"weather_descr":"Brief Showers Possible"},"1515888000":{"new":true,"wind_dir":308.0,"swell_dir":[289.81],"swell_size":[3.9],"wind_speed":28.0,"probability":100.0,"swell_period":[15.0],"weather_temp":12.0,"weather_descr":"Brief Showers Possible"},"1515898800":{"new":true,"wind_dir":321.0,"swell_dir":[291.8,250.0],"swell_size":[3.8,0.5],"wind_speed":28.0,"probability":100.0,"swell_period":[14.0,15.0],"weather_temp":12.0,"weather_descr":"Brief Showers Possible"},"1515909600":{"new":true,"wind_dir":334.0,"swell_dir":[293.41,250.0],"swell_size":[3.7,0.5],"wind_speed":27.0,"probability":100.0,"swell_period":[14.0,14.0],"weather_temp":12.0,"weather_descr":"Brief Showers Possible"},"1515920400":{"new":true,"wind_dir":335.0,"swell_dir":[295.09,252.0],"swell_size":[3.5,0.5],"wind_speed":24.0,"probability":100.0,"swell_period":[14.0,14.0],"weather_temp":12.0,"weather_descr":"Brief Showers Possible"},"1515931200":{"new":true,"wind_dir":330.0,"swell_dir":[297.21,252.0],"swell_size":[3.5,0.5],"wind_speed":31.0,"probability":100.0,"swell_period":[14.0,14.0],"weather_temp":12.0,"weather_descr":"Light Showers Possible"},"1515942000":{"new":true,"wind_dir":352.0,"swell_dir":[300.23,251.0],"swell_size":[3.4,0.4],"wind_speed":31.0,"probability":100.0,"swell_period":[13.0,14.0],"weather_temp":13.0,"weather_descr":"Brief Showers Possible"},"1515952800":{"new":true,"wind_dir":25.0,"swell_dir":[302.66,251.0],"swell_size":[3.2,0.4],"wind_speed":26.0,"probability":100.0,"swell_period":[13.0,14.0],"weather_temp":12.0,"weather_descr":"Brief Showers Possible"},"1515963600":{"new":true,"wind_dir":33.0,"swell_dir":[305.21,253.0],"swell_size":[3.1,0.4],"wind_speed":30.0,"probability":100.0,"swell_period":[13.0,13.0],"weather_temp":12.0,"weather_descr":"Clear"},"1515974400":{"new":true,"wind_dir":37.0,"swell_dir":[307.07,253.0],"swell_size":[2.9,0.3],"wind_speed":25.0,"probability":100.0,"swell_period":[13.0,13.0],"weather_temp":12.0,"weather_descr":"Clear"},"1515985200":{"new":true,"wind_dir":46.0,"swell_dir":[307.86,252.0],"swell_size":[2.6,0.3],"wind_speed":22.0,"probability":100.0,"swell_period":[13.0,13.0],"weather_temp":12.0,"weather_descr":"Clear"},"1515996000":{"new":true,"wind_dir":38.0,"swell_dir":[310.95,281.0],"swell_size":[2.3,0.7],"wind_speed":18.0,"probability":100.0,"swell_period":[12.0,13.0],"weather_temp":12.0,"weather_descr":"Clear"},"1516006800":{"new":true,"wind_dir":19.0,"swell_dir":[309.27,253.0],"swell_size":[2.3,0.2],"wind_speed":21.0,"probability":100.0,"swell_period":[12.0,13.0],"weather_temp":12.0,"weather_descr":"Sunny"},"1516017600":{"new":true,"wind_dir":21.0,"swell_dir":[310.31,254.0],"swell_size":[2.1,0.2],"wind_speed":20.0,"probability":100.0,"swell_period":[12.0,13.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516028400":{"new":true,"wind_dir":5.0,"swell_dir":[311.32,254.0],"swell_size":[2.0,0.2],"wind_speed":22.0,"probability":100.0,"swell_period":[12.0,12.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516039200":{"new":true,"wind_dir":6.0,"swell_dir":[312.43,252.0],"swell_size":[1.9,0.1],"wind_speed":24.0,"probability":100.0,"swell_period":[11.0,12.0],"weather_temp":14.0,"weather_descr":"Clear"},"1516050000":{"new":true,"wind_dir":13.0,"swell_dir":[312.84,253.0],"swell_size":[1.9,0.1],"wind_speed":21.0,"probability":100.0,"swell_period":[11.0,12.0],"weather_temp":14.0,"weather_descr":"Clear"},"1516060800":{"new":true,"wind_dir":8.0,"swell_dir":[311.38,332.0],"swell_size":[1.7,0.4],"wind_speed":15.0,"probability":100.0,"swell_period":[11.0,14.0],"weather_temp":14.0,"weather_descr":"Clear"},"1516071600":{"new":true,"wind_dir":27.0,"swell_dir":[310.08,332.0],"swell_size":[1.6,0.5],"wind_speed":12.0,"probability":100.0,"swell_period":[11.0,14.0],"weather_temp":14.0,"weather_descr":"Clear"},"1516093200":{"new":true,"wind_dir":256.0,"swell_dir":[308.18,333.0],"swell_size":[1.5,0.8],"wind_speed":8.0,"probability":100.0,"swell_period":[11.0,13.0],"weather_temp":14.0,"weather_descr":"Fair"},"1516104000":{"new":true,"wind_dir":291.0,"swell_dir":[328.76,291.0],"swell_size":[1.3,1.0],"wind_speed":6.0,"probability":77.0,"swell_period":[14.0,10.0],"weather_temp":15.0,"weather_descr":"Sunny"},"1516114800":{"new":true,"wind_dir":331.0,"swell_dir":[330.26,300.0],"swell_size":[2.4,1.2],"wind_speed":12.0,"probability":77.0,"swell_period":[15.0,11.0],"weather_temp":15.0,"weather_descr":"Mist"},"1516125600":{"new":true,"wind_dir":350.0,"swell_dir":[327.35],"swell_size":[3.3],"wind_speed":21.0,"probability":81.0,"swell_period":[17.0],"weather_temp":15.0,"weather_descr":"Clear"},"1516136400":{"new":true,"wind_dir":359.0,"swell_dir":[329.1],"swell_size":[3.8],"wind_speed":24.0,"probability":81.0,"swell_period":[17.0],"weather_temp":15.0,"weather_descr":"Clear"},"1516147200":{"new":true,"wind_dir":1.0,"swell_dir":[330.13],"swell_size":[4.2],"wind_speed":23.0,"probability":95.0,"swell_period":[17.0],"weather_temp":15.0,"weather_descr":"Clear"},"1516158000":{"new":true,"wind_dir":5.0,"swell_dir":[332.69,302.0],"swell_size":[4.4,1.0],"wind_speed":29.0,"probability":95.0,"swell_period":[17.0,13.0],"weather_temp":15.0,"weather_descr":"Clear"},"1516168800":{"new":true,"wind_dir":4.0,"swell_dir":[332.32],"swell_size":[4.8],"wind_speed":31.0,"probability":90.0,"swell_period":[17.0],"weather_temp":15.0,"weather_descr":"Clear"},"1516179600":{"new":true,"wind_dir":12.0,"swell_dir":[333.62],"swell_size":[5.1],"wind_speed":38.0,"probability":90.0,"swell_period":[17.0],"weather_temp":14.0,"weather_descr":"Fair"},"1516190400":{"new":true,"wind_dir":12.0,"swell_dir":[334.7],"swell_size":[5.4],"wind_speed":40.0,"probability":85.0,"swell_period":[17.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516201200":{"new":true,"wind_dir":11.0,"swell_dir":[335.7],"swell_size":[6.0],"wind_speed":43.0,"probability":85.0,"swell_period":[18.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516212000":{"new":true,"wind_dir":13.0,"swell_dir":[336.08],"swell_size":[6.7],"wind_speed":41.0,"probability":100.0,"swell_period":[20.0],"weather_temp":13.0,"weather_descr":"Clear"},"1516222800":{"new":true,"wind_dir":15.0,"swell_dir":[335.77],"swell_size":[7.0],"wind_speed":40.0,"probability":100.0,"swell_period":[19.0],"weather_temp":14.0,"weather_descr":"Clear"},"1516233600":{"new":true,"wind_dir":16.0,"swell_dir":[334.97],"swell_size":[6.9],"wind_speed":38.0,"probability":95.0,"swell_period":[19.0],"weather_temp":14.0,"weather_descr":"Clear"},"1516244400":{"new":true,"wind_dir":16.0,"swell_dir":[334.02],"swell_size":[6.5],"wind_speed":39.0,"probability":95.0,"swell_period":[19.0],"weather_temp":13.0,"weather_descr":"Clear"},"1516255200":{"new":true,"wind_dir":17.0,"swell_dir":[332.99],"swell_size":[6.1],"wind_speed":38.0,"probability":100.0,"swell_period":[18.0],"weather_temp":13.0,"weather_descr":"Clear"},"1516266000":{"new":true,"wind_dir":16.0,"swell_dir":[332.19],"swell_size":[5.6],"wind_speed":39.0,"probability":100.0,"swell_period":[18.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516276800":{"new":true,"wind_dir":15.0,"swell_dir":[331.44],"swell_size":[5.1],"wind_speed":38.0,"probability":100.0,"swell_period":[18.0],"weather_temp":13.0,"weather_descr":"Fair"},"1516287600":{"new":true,"wind_dir":7.0,"swell_dir":[330.32],"swell_size":[4.7],"wind_speed":34.0,"probability":100.0,"swell_period":[17.0],"weather_temp":14.0,"weather_descr":"Sunny"},"1516298400":{"new":true,"wind_dir":7.0,"swell_dir":[330.11],"swell_size":[4.5],"wind_speed":35.0,"probability":100.0,"swell_period":[17.0],"weather_temp":15.0,"weather_descr":"Clear"},"1516309200":{"new":true,"wind_dir":7.0,"swell_dir":[328.99,353.0],"swell_size":[4.3,1.7],"wind_speed":45.0,"probability":100.0,"swell_period":[17.0,6.0],"weather_temp":14.0,"weather_descr":"Clear"},"1516320000":{"new":true,"wind_dir":8.0,"swell_dir":[330.01,349.0],"swell_size":[4.3,2.4],"wind_speed":48.0,"probability":100.0,"swell_period":[16.0,7.0],"weather_temp":14.0,"weather_descr":"Clear"},"1516330800":{"new":true,"wind_dir":12.0,"swell_dir":[336.2],"swell_size":[5.1],"wind_speed":54.0,"probability":100.0,"swell_period":[16.0],"weather_temp":13.0,"weather_descr":"Clear"},"1516341600":{"new":true,"wind_dir":14.0,"swell_dir":[337.45],"swell_size":[5.1],"wind_speed":54.0,"probability":90.0,"swell_period":[15.0],"weather_temp":13.0,"weather_descr":"Clear"},"1516352400":{"new":true,"wind_dir":14.0,"swell_dir":[338.28],"swell_size":[5.0],"wind_speed":53.0,"probability":90.0,"swell_period":[15.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516363200":{"new":true,"wind_dir":13.0,"swell_dir":[338.43,251.0],"swell_size":[4.9,0.2],"wind_speed":49.0,"probability":90.0,"swell_period":[15.0,14.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516374000":{"new":true,"wind_dir":8.0,"swell_dir":[337.71,252.0],"swell_size":[4.8,0.2],"wind_speed":45.0,"probability":90.0,"swell_period":[15.0,14.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516384800":{"new":true,"wind_dir":5.0,"swell_dir":[336.98,252.0],"swell_size":[4.7,0.2],"wind_speed":43.0,"probability":80.0,"swell_period":[15.0,14.0],"weather_temp":13.0,"weather_descr":"Clear"},"1516395600":{"new":true,"wind_dir":1.0,"swell_dir":[335.9],"swell_size":[4.6],"wind_speed":37.0,"probability":80.0,"swell_period":[15.0],"weather_temp":13.0,"weather_descr":"Clear"},"1516406400":{"new":true,"wind_dir":348.0,"swell_dir":[334.88],"swell_size":[4.5],"wind_speed":34.0,"probability":85.0,"swell_period":[15.0],"weather_temp":14.0,"weather_descr":"Mostly Clear"},"1516417200":{"new":true,"wind_dir":333.0,"swell_dir":[333.9],"swell_size":[4.3],"wind_speed":35.0,"probability":85.0,"swell_period":[15.0],"weather_temp":14.0,"weather_descr":"Mostly Cloudy"},"1516428000":{"new":true,"wind_dir":308.0,"swell_dir":[332.47,252.0],"swell_size":[4.2,0.2],"wind_speed":36.0,"probability":45.0,"swell_period":[15.0,14.0],"weather_temp":15.0,"weather_descr":"Mostly Cloudy"},"1516438800":{"new":true,"wind_dir":348.0,"swell_dir":[332.57],"swell_size":[4.2],"wind_speed":39.0,"probability":45.0,"swell_period":[15.0],"weather_temp":15.0,"weather_descr":"Brief Showers"},"1516449600":{"new":true,"wind_dir":359.0,"swell_dir":[334.85],"swell_size":[4.3],"wind_speed":42.0,"probability":25.0,"swell_period":[15.0],"weather_temp":13.0,"weather_descr":"Brief Showers"},"1516460400":{"new":true,"wind_dir":300.0,"swell_dir":[324.65],"swell_size":[3.1],"wind_speed":37.0,"probability":25.0,"swell_period":[14.0],"weather_temp":15.0,"weather_descr":"Brief Showers"},"1516471200":{"new":true,"wind_dir":308.0,"swell_dir":[323.97],"swell_size":[3.2],"wind_speed":37.0,"probability":30.0,"swell_period":[13.0],"weather_temp":15.0,"weather_descr":"Brief Showers"},"1516482000":{"new":true,"wind_dir":322.0,"swell_dir":[325.84],"swell_size":[3.3],"wind_speed":34.0,"probability":30.0,"swell_period":[13.0],"weather_temp":15.0,"weather_descr":"Brief Showers"},"1516492800":{"new":true,"wind_dir":335.0,"swell_dir":[328.52],"swell_size":[3.4],"wind_speed":32.0,"probability":45.0,"swell_period":[13.0],"weather_temp":15.0,"weather_descr":"Light Showers"},"1516503600":{"new":true,"wind_dir":358.0,"swell_dir":[329.97],"swell_size":[3.4],"wind_speed":35.0,"probability":45.0,"swell_period":[12.0],"weather_temp":14.0,"weather_descr":"Clear"},"1516514400":{"new":true,"wind_dir":358.0,"swell_dir":[330.37],"swell_size":[3.2],"wind_speed":35.0,"probability":48.0,"swell_period":[12.0],"weather_temp":14.0,"weather_descr":"Mostly Cloudy"},"1516525200":{"new":true,"wind_dir":360.0,"swell_dir":[330.33],"swell_size":[3.0],"wind_speed":33.0,"probability":48.0,"swell_period":[12.0],"weather_temp":13.0,"weather_descr":"Cloudy"},"1516536000":{"new":true,"wind_dir":359.0,"swell_dir":[329.2],"swell_size":[2.8],"wind_speed":27.0,"probability":55.0,"swell_period":[12.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516546800":{"new":true,"wind_dir":357.0,"swell_dir":[327.77],"swell_size":[2.6],"wind_speed":24.0,"probability":55.0,"swell_period":[12.0],"weather_temp":13.0,"weather_descr":"Sunny"},"1516644000":{"new":true,"wind_dir":286.0,"swell_dir":[341.18,302.0,284.0],"swell_size":[1.0,1.1,0.1],"wind_speed":17.0,"probability":36.0,"swell_period":[10.0,9.0,21.0],"weather_temp":15.0,"weather_descr":"Brief Showers Possible"}}'
end
