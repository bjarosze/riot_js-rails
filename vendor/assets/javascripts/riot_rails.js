;(function($) {

  var riotRails = {
    componentSelector: '.riot-rails-component',
    mounted: [],
    mount: function(selector) {
      var component = $(selector);
      var opts = component.data('opts');
      var mounted = riot.mount(selector, opts);
      this.mounted.push(mounted[0]);
    },
    unmountAll: function () {
      $.each(this.mounted, function(index, component) {
        component.unmount();
      });
      this.mounted = [];
    },
    mountAll: function() {
      var self = this;
      $(self.componentSelector).each(function(){
        self.mount('#' + $(this).attr('id'));
      });
    }
  };

  var handleNativePageLoad = function () {
    $(function() {
      riotRails.mountAll();
    });
  };

  var handleTurbolinksPageLoad = function () {
    var unmountEvent;

    if (Turbolinks.EVENTS) {
      unmountEvent = Turbolinks.EVENTS.BEFORE_UNLOAD;
    } else {
      unmountEvent = 'page:receive';
      Turbolinks.pagesCached(0);

      if (window.ReactRailsUJS.RAILS_ENV_DEVELOPMENT) {
        console.warn('The Turbolinks cache has been disabled (Turbolinks >= 2.4.0 is recommended).');
      }
    }

    $(document).on('page:change', function(){
      riotRails.mountAll();
    });

    $(document).on(unmountEvent, function(){
      riotRails.unmountAll();
    });
  };

  if (typeof Turbolinks !== 'undefined' && Turbolinks.supported) {
    handleTurbolinksPageLoad();
  } else {
    handleNativePageLoad();
  }

})(jQuery);
