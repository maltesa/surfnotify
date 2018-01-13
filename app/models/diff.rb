class Diff
  attr_reader :matches

  def initialize(old:, new:)
    @old = old
    @new = new
    @matches = calc_forecast_diff
    @new_matches = nil
    @passed_matches = nil
  end

  # are there matches?
  def matches?
    @matches.present?
  end

  # only show new matches
  def new_matches
    @new_matches ||= @matches.select { |_, data| data['new'] }
  end

  # are there new matches?
  def new_matches?
    new_matches.present?
  end

  def changed_matches
    @changed_matches ||= @matches.reject { |_, data| data['new'] }
  end

  def changed_matches?
    changed_matches.present?
  end

  # filter former matches which do not match any more (and are in the future)
  def passed_matches
    return @passed_matches if @passed_matches.present?
    now_ts = Time.now.to_i
    olf_diff_ts = @old.keys - @new.keys
    keys = olf_diff_ts.reject { |ts| ts.to_i < now_ts.to_i }
    @passed_matches = @old.values_at(*keys)
  end

  # are there former matches which do not match in the new data?
  def passed_matches?
    passed_matches.present?
  end

  private

  # creates diff between old and new forecasts
  def calc_forecast_diff
    diff = {}
    @new.each do |timestamp, unit_new|
      unit_old = @old[timestamp]

      # ignore 'new' key since it is meta data
      unit_old.delete('new') unless unit_old.nil?
      unit_new.delete('new') unless unit_new.nil?

      # old forecast unit found?
      if unit_old.present?
        # create and save diff between old and new unit if diff isnt empty
        if (unit_diff = hash_diff(unit_old, unit_new)).present?
          diff[timestamp] = unit_diff.tap { |u| u['new'] = false }
        end
      else
        diff[timestamp] = unit_new.tap { |u| u['new'] = true }
      end
    end
    diff
  end

  def hash_diff(a, b)
    (a.keys | b.keys).each_with_object({}) do |k, diff|
      next diff if a[k].eql?(b[k])
      diff[k] = if a[k].is_a?(Hash) && b[k].is_a?(Hash)
                  hash_diff(a[k], b[k])
                else
                  [a[k], b[k]]
                end
    end
  end
end
