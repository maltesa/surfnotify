# Helper methods to be used everywhere
module Helpers
  # creates diff between old and new forecasts
  def self.forecast_diff(old:, new:)
    diff = {}
    new.each do |timestamp, unit_new|
      unit_old = old[timestamp]
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

  def self.hash_diff(a, b)
    (a.keys | b.keys).each_with_object({}) do |k, diff|
      if !a[k].eql?(b[k])
        diff[k] = if a[k].is_a?(Hash) && b[k].is_a?(Hash)
                    hash_diff(a[k], b[k])
                  else
                    [a[k], b[k]]
                  end
      end
      diff
    end
  end
end
