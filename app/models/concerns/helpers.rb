# Helper methods to be used everywhere
module Helpers
  # creates diff between old and new forecasts
  def self.forecast_diff(old:, new:)
    new.reduce([]) do |diff, unit_new|
      unit_old = old.find { |u| u[:time] == unit_new[:time] }
      if unit_old.present?
        unit_diff = hash_diff(unit_old, unit_new)
        diff << unit_diff.tap { |u| u[:new] = false } if unit_diff.present?
      else
        diff << unit_new.tap { |u| u[:new] = true }
      end
    end
  end

  def self.hash_diff(a, b)
    (a.keys | b.keys).each_with_object({}) do |diff, k|
      if a[k] != b[k]
        diff[k] = if a[k].is_a?(Hash) && b[k].is_a?(Hash)
                    a[k].deep_diff(b[k])
                  else
                    [a[k], b[k]]
                  end
      end
      diff
    end
  end
end
