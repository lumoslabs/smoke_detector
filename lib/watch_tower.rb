require 'watch_tower/exceptions'
require 'watch_tower/providers'
require 'watch_tower/controller_methods'
require 'watch_tower/engine'

module WatchTower

  # Reports an exception through WatchTower. Returns nil.
  #
  # @example
  #   begin
  #     foo = bar
  #   rescue => e
  #     WatchTower.alert(e)
  #   end
  #
  # @param exception [Exception] The exception object to report
  # @option options [Hash] :data Additional data to include alongside the exception
  def self.alert(exception, options = {})
    self.providers.each {|provider| provider.alert(exception, options) }
    nil
  end

  # Records a message through WatchTower. Returns nil.
  #
  # @example
  #   WatchTower.message('Look out!')
  #
  # @param message [String] The message to be recorded
  # @option options [Hash] Additional data to include alongside the message
  # @option options [Hash] :level The level at which to report the message
  def self.message(message, options = {})
    self.providers.each {|provider| provider.message(message, options) }
    nil
  end

end
