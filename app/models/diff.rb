class Diff
  attr_reader :new_data_flag
  alias new_data? new_data_flag

  def initialize(old:, new:)
    @old = old
    @new = new
    @new_data_flag = false
    @diff = calc_forecast_diff
  end

  # only show new data
  def new_data
    @diff.select { |_, data| data['new'] }
  end

  # filter former matches which do not match any more (and are in the future)
  def passed_matches
    now_ts = Time.now.to_i
    olf_diff_ts = @old.keys - @new.keys
    keys = olf_diff_ts.reject { |ts| ts < now_ts }
    old_diff.values_at(*keys)
  end

  # forward method calls to actual diff
  def method_missing(name, args)
    @diff.send(name, *args)
  end

  def respond_to_missing?(name)
    @diff.respond_to? name
  end

  private

  # creates diff between old and new forecasts
  def calc_forecast_diff
    diff = {}
    @new.each do |timestamp, unit_new|
      unit_old = @old[timestamp]
      # old forecast unit found?
      if unit_old.present?
        # create and save diff between old and new unit if diff isnt empty
        if (unit_diff = hash_diff(unit_old, unit_new)).present?
          diff[timestamp] = unit_diff.tap { |u| u['new'] = false }
        end
      else
        # the new forecast also contains completely new data
        @new_data_flag = true
        diff[timestamp] = unit_new.tap { |u| u['new'] = true }
      end
    end
    diff
  end

  def hash_diff(a, b)
    (a.keys | b.keys).each_with_object({}) do |k, diff|
      next diff unless a[k].eql?(b[k])
      diff[k] = if a[k].is_a?(Hash) && b[k].is_a?(Hash)
                  hash_diff(a[k], b[k])
                else
                  [a[k], b[k]]
                end
    end
  end
end
