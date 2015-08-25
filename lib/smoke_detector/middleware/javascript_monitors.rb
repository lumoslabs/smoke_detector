module SmokeDetector
  class JavaScriptMonitors

    TARGET_TAG = '<head>'
    ACCEPTABLE_CONTENT = /text\/html|application\/xhtml\+xml/
    # barely even an important number, but we want to ensure the script is longer than a few characters
    MINIMUM_SIZE_OF_JS = 10

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if monitor?(headers)
        body = ''
        response.each { |part| body << part }
        if index = body.rindex(TARGET_TAG)
          body.insert(index + TARGET_TAG.length + 1, monitoring_code)
          headers["Content-Length"] = body.length.to_s
          response = [body]
        end
      end

      [status, headers, response]
    end

    private

    def monitoring_code
      @monitoring_code ||= SmokeDetector.providers.map(&:client_monitoring_code).join('')
    end

    def monitor?(headers)
      # minified code may not be UTF8 compliant, so you can't use present? reliably
      headers["Content-Type"] =~ ACCEPTABLE_CONTENT && monitoring_code.size > MINIMUM_SIZE_OF_JS
    end
  end
end
