class Widget

  def self.raise_bubble_up
    raise 'deep_bubble_up'
  end

  def self.raise_catch
    raise 'deep_catch'
  rescue
    SmokeDetector.alert($!)
  end

end
