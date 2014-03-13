module SmokeDetector::Providers

  class Rollbar < Provider

    def initialize(api_key, client_api_key = nil, settings = {})
      super
      ::Rollbar.configure do |c|
        c.environment = ::Rails.env # Rollbar sets this to 'unspecified' by default

        c.access_token = api_key
        apply_configuration_settings(c, settings)

        # set Rollbar defaults
        c.logger ||= ::Rails.logger
        c.root ||= ::Rails.root
        c.framework = "Rails: #{::Rails::VERSION::STRING}"
        c.filepath ||= ::Rails.application.class.parent_name + '.rollbar'
      end
    end

    def alert(exception, options = {})
      if data = options.delete(:data)
        exception.message << data.to_s
      end

      ::Rollbar.report_exception(exception)
    end

    def message(message, options = {})
      level = options.delete(:level) || 'info'
      ::Rollbar.report_message(message, level, options)
    end

    def client_monitoring_code
      return '' if client_api_key.blank?
      @client_monitoring_code ||= <<-JS
        <script>
          var _rollbarConfig = {
              accessToken: "#{@client_api_key}",
              captureUncaught: true,
              payload: {
                  environment: "#{::Rails.env}"
              }
          };
          #{url_filter_snippet}
          !function(a,b){function c(b){this.shimId=++f,this.notifier=null,this.parentShim=b,this.logger=function(){},a.console&&void 0===a.console.shimId&&(this.logger=a.console.log)}function d(b){var d=c;return e(function(){if(this.notifier)return this.notifier[b].apply(this.notifier,arguments);var c=this,e="scope"===b;e&&(c=new d(this));var f=Array.prototype.slice.call(arguments,0),g={shim:c,method:b,args:f,ts:new Date};return a._rollbarShimQueue.push(g),e?c:void 0})}function e(a,b){return b=b||this.logger,function(){try{return a.apply(this,arguments)}catch(c){b("Rollbar internal error:",c)}}}var f=0;c.init=function(a,b){var d=b.globalAlias||"Rollbar";if("object"==typeof a[d])return a[d];a._rollbarShimQueue=[],b=b||{};var f=new c;return e(function(){if(f.configure(b),b.captureUncaught){var c=a.onerror;a.onerror=function(){f.uncaughtError.apply(f,arguments),c&&c.apply(a,arguments)}}return a[d]=f,f},f.logger)()},c.prototype.loadFull=function(a,b,c,d){var f=e(function(){var a=b.createElement("script"),e=b.getElementsByTagName("script")[0];a.src=d.rollbarJsUrl,a.async=!c,a.onload=g,e.parentNode.insertBefore(a,e)},this.logger),g=e(function(){if(void 0===a._rollbarPayloadQueue)for(var b,c,d,e,f=new Error("rollbar.js did not load");b=a._rollbarShimQueue.shift();)for(d=b.args,e=0;e<d.length;++e)if(c=d[e],"function"==typeof c){c(f);break}},this.logger);e(function(){c?f():a.addEventListener?a.addEventListener("load",f,!1):a.attachEvent("onload",f)},this.logger)()};for(var g="log,debug,info,warn,warning,error,critical,global,configure,scope,uncaughtError".split(","),h=0;h<g.length;++h)c.prototype[g[h]]=d(g[h]);var i="//d37gvrvc0wt4s1.cloudfront.net/js/v1.0/rollbar.min.js";_rollbarConfig.rollbarJsUrl=_rollbarConfig.rollbarJsUrl||i;var j=c.init(a,_rollbarConfig);j.loadFull(a,b,!1,_rollbarConfig)}(window,document);
        </script>
      JS
    end

    def url_filter_snippet
      unless @js_url_filter.blank?
        <<-JS
        _rollbarConfig.checkIgnore = function(isUncaught, args, payload) {
          try {
            var filename = payload.data.body.trace.frames[0].filename;
            if (isUncaught && !filename.match(/#{@js_url_filter}/)) {
              return true;
            }
          } catch (e) {}
          return false;
        };
        JS
      end
    end

    module ControllerMethods
      def alert_smoke_detector(exception, options = {})
        super if defined?(super)

        if data = options.delete(:data)
          exception.message << data.to_s
        end

        ::Rollbar.report_exception(exception, rollbar_request_data, rollbar_person_data)
      end
    end
  end
end
