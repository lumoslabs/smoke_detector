require 'json'
require 'rollbar'

module SmokeDetector::Providers

  class Rollbar < Provider
    def initialize(api_key, client_settings = {}, settings = {})
      super
      ::Rollbar.configure do |c|
        c.environment = ::Rails.env # Rollbar sets this to 'unspecified' by default
        c.enabled = settings.fetch(:enabled, true)
        c.access_token = api_key
        apply_configuration_settings(c, settings)

        # set Rollbar defaults
        c.logger ||= ::Rails.logger
        c.root ||= ::Rails.root
        c.framework = "Rails: #{::Rails::VERSION::STRING}"
        c.filepath ||= ::Rails.application.class.parent_name + '.rollbar'
      end

      @client_settings = default_client_settings
      migrate_old_client_setting_syntax(client_settings)
      @client_settings.deep_merge!(client_settings) if client_settings.present?
    end

    def alert(exception, options = {})
      if data = options.delete(:data)
        exception.message << data.to_s
      end

      ::Rollbar.error(exception)
    end

    def message(message, options = {})
      level = options.delete(:level) || 'info'
      ::Rollbar.log(level, message, options)
    end

    def default_client_settings
      { captureUncaught: true, payload: { environment: ::Rails.env } }
    end

    def client_monitoring_code
      return '' if client_settings[:api_key].blank?
      client_settings[:accessToken] = client_settings.delete(:api_key)
      @client_monitoring_code ||= (<<-RBC + <<-'JS').freeze
        <script>
          var _rollbarConfig = #{client_settings.to_json};
        </script>
      RBC
        <script>
        !function(a,b){function c(b){this.shimId=++h,this.notifier=null,this.parentShim=b,this.logger=function(){},a.console&&void 0===a.console.shimId&&(this.logger=a.console.log)}function d(b,c,d){a._rollbarWrappedError&&(d[4]||(d[4]=a._rollbarWrappedError),d[5]||(d[5]=a._rollbarWrappedError._rollbarContext),a._rollbarWrappedError=null),b.uncaughtError.apply(b,d),c&&c.apply(a,d)}function e(b){var d=c;return g(function(){if(this.notifier)return this.notifier[b].apply(this.notifier,arguments);var c=this,e="scope"===b;e&&(c=new d(this));var f=Array.prototype.slice.call(arguments,0),g={shim:c,method:b,args:f,ts:new Date};return a._rollbarShimQueue.push(g),e?c:void 0})}function f(a,b){if(b.hasOwnProperty&&b.hasOwnProperty("addEventListener")){var c=b.addEventListener;b.addEventListener=function(b,d,e){c.call(this,b,a.wrap(d),e)};var d=b.removeEventListener;b.removeEventListener=function(a,b,c){d.call(this,a,b&&b._wrapped?b._wrapped:b,c)}}}function g(a,b){return b=b||this.logger,function(){try{return a.apply(this,arguments)}catch(c){b("Rollbar internal error:",c)}}}var h=0;c.init=function(a,b){var e=b.globalAlias||"Rollbar";if("object"==typeof a[e])return a[e];a._rollbarShimQueue=[],a._rollbarWrappedError=null,b=b||{};var h=new c;return g(function(){if(h.configure(b),b.captureUncaught){var c=a.onerror;a.onerror=function(){var a=Array.prototype.slice.call(arguments,0);d(h,c,a)};var g,i,j="EventTarget,Window,Node,ApplicationCache,AudioTrackList,ChannelMergerNode,CryptoOperation,EventSource,FileReader,HTMLUnknownElement,IDBDatabase,IDBRequest,IDBTransaction,KeyOperation,MediaController,MessagePort,ModalWindow,Notification,SVGElementInstance,Screen,TextTrack,TextTrackCue,TextTrackList,WebSocket,WebSocketWorker,Worker,XMLHttpRequest,XMLHttpRequestEventTarget,XMLHttpRequestUpload".split(",");for(g=0;g<j.length;++g)i=j[g],a[i]&&a[i].prototype&&f(h,a[i].prototype)}return a[e]=h,h},h.logger)()},c.prototype.loadFull=function(a,b,c,d,e){var f=g(function(){var a=b.createElement("script"),e=b.getElementsByTagName("script")[0];a.src=d.rollbarJsUrl,a.async=!c,a.onload=h,e.parentNode.insertBefore(a,e)},this.logger),h=g(function(){var b;if(void 0===a._rollbarPayloadQueue){var c,d,f,g;for(b=new Error("rollbar.js did not load");c=a._rollbarShimQueue.shift();)for(f=c.args,g=0;g<f.length;++g)if(d=f[g],"function"==typeof d){d(b);break}}"function"==typeof e&&e(b)},this.logger);g(function(){c?f():a.addEventListener?a.addEventListener("load",f,!1):a.attachEvent("onload",f)},this.logger)()},c.prototype.wrap=function(b,c){try{var d;if(d="function"==typeof c?c:function(){return c||{}},"function"!=typeof b)return b;if(b._isWrap)return b;if(!b._wrapped){b._wrapped=function(){try{return b.apply(this,arguments)}catch(c){throw c._rollbarContext=d(),c._rollbarContext._wrappedSource=b.toString(),a._rollbarWrappedError=c,c}},b._wrapped._isWrap=!0;for(var e in b)b.hasOwnProperty(e)&&(b._wrapped[e]=b[e])}return b._wrapped}catch(f){return b}};for(var i="log,debug,info,warn,warning,error,critical,global,configure,scope,uncaughtError".split(","),j=0;j<i.length;++j)c.prototype[i[j]]=e(i[j]);var k="//d37gvrvc0wt4s1.cloudfront.net/js/v1.1/rollbar.min.js";_rollbarConfig.rollbarJsUrl=_rollbarConfig.rollbarJsUrl||k;var l=c.init(a,_rollbarConfig);l.loadFull(a,b,!1,_rollbarConfig)}(window,document);
        </script>
      JS
    end

    module ControllerMethods
      def alert_smoke_detector(exception, options = {})
        super if defined?(super)

        if data = options.delete(:data)
          exception.message << data.to_s
        end

        ::Rollbar.error(exception, rollbar_request_data, rollbar_person_data)
      end
    end

    private
    def migrate_old_client_setting_syntax(settings)
      return unless settings.present?
      whitelist    = settings.delete(:host_whitelist)
      ignored_msgs = settings.delete(:ignored_messages)

      settings[:hostWhiteList]   = whitelist if whitelist
      settings[:ignoredMessages] = ignored_msgs if ignored_msgs
      settings
    end
  end
end
