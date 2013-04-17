require 'smoke_detector/exceptions'
require 'smoke_detector/providers'
require 'smoke_detector/controller_methods'
require 'smoke_detector/engine'

module SmokeDetector

  # Reports an exception through SmokeDetector. Returns nil.
  #
  # @example
  #   begin
  #     foo = bar
  #   rescue => e
  #     SmokeDetector.alert(e)
  #   end
  #
  # @param exception [Exception] The exception object to report
  # @option options [Hash] :data Additional data to include alongside the exception
  def self.alert(exception, options = {})
    self.providers.each {|provider| provider.alert(exception, options) }
    nil
  end

  # Records a message through SmokeDetector. Returns nil.
  #
  # @example
  #   SmokeDetector.message('Look out!')
  #
  # @param message [String] The message to be recorded
  # @option options [Hash] Additional data to include alongside the message
  # @option options [Hash] :level The level at which to report the message
  def self.message(message, options = {})
    self.providers.each {|provider| provider.message(message, options) }
    nil
  end

end
