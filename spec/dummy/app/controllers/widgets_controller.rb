class WidgetsController < ApplicationController

  def bubble_up
    raise 'bubble_up'
    render :index
  end

  def deep_bubble_up
    Widget.raise_bubble_up
  end

  def catch
    begin
      raise 'catch'
    rescue
      alert_watch_tower($!)
    end
    render :index
  end

  def deep_catch
    Widget.raise_catch
    render :index
  end

end
