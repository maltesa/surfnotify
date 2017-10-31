# Helper methods to be used everywhere
module Helpers
  # creates diff between old and new forecasts
  def self.forecast_diff(old:, new:)
    new.reduce([]) do |diff, unit_new|
      unit_old = old.find { |u| u[:time] == unit_new[:time] }
      if unit_old.present?
        if (unit_diff = hash_diff(unit_old, unit_new)).present?
          diff << unit_diff.tap { |u| u[:new] = false }
        else
          diff
        end
      else
        diff << unit_new.tap { |u| u[:new] = true }
      end
    end
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
