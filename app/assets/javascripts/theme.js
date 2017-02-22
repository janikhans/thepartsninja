$(function () {
  navbar.initialize();

  pricing_charts.initialize();

  global_notifications.initialize();


  retina.initialize();

});

var navbar = {
  initialize: function () {
    this.themeSites();

    if (!window.utils.isMobile()) {
      this.dropdowns();
    }
  },

  dropdowns: function () {
    var $dropdowns = $('.navbar-nav li.dropdown')
    $dropdowns.each(function (index, item) {
      var $item = $(this)

      $item.hover(function () {
          $item.addClass('open')
      }, function () {
          $item.removeClass('open')
      })
    })
  },

  themeSites: function () {
    var $trigger = $("[data-toggle-header-sections-menu]"),
      $header_panel = $("#header-sections-menu"),
      $body = $("body");

    $trigger.click(function (e) {
      e.preventDefault();

      $body.toggleClass("header-panel-visible");

      if ($body.hasClass("header-panel-visible")) {
        $trigger.find("i").removeClass("ion-plus").addClass("ion-minus");

        var $navbar = $trigger.closest(".navbar");

        if ($navbar.hasClass("navbar-transparent")) {
          $header_panel.removeClass("fixed");
          return;
        }

        if ($navbar.hasClass("navbar-fixed-top")) {
          $header_panel.addClass("fixed");
        }
      } else {
        $trigger.find("i").removeClass("ion-minus").addClass("ion-plus");
      }
    })
  }
};

var global_notifications = {
  initialize: function () {
    setTimeout(function () {
      $(".global-notification").removeClass("uber-notification").addClass("uber-notification-remove");
    }, 5000);
  }
};

var pricing_charts = {
  initialize: function () {
    var tabs = $(".pricing-charts-tabs .tab"),
        prices = $(".pricing-charts .chart header .price");

    tabs.click(function () {
      tabs.removeClass("active");
      $(this).addClass("active");

      var period = $(this).data("tab");
      var price_out = prices.filter(":not(."+ period +")");
      price_out.addClass("go-out");
      prices.filter("." + period + "").addClass("active");

      setTimeout(function () {
        price_out.removeClass("go-out").removeClass("active");
      }, 250);
    });
  }
};

var retina = {
  initialize: function () {
    if(window.devicePixelRatio >= 1.2){
      $("[data-2x]").each(function(){
        if(this.tagName == "IMG"){
          $(this).attr("src",$(this).attr("data-2x"));
        } else {
          $(this).css({"background-image":"url("+$(this).attr("data-2x")+")"});
        }
      });
    }
  }
};

window.utils = {
  isFirefox: function () {
    return navigator.userAgent.toLowerCase().indexOf('firefox') > -1;
  },

  // Returns a function, that, as long as it continues to be invoked, will not
  // be triggered. The function will be called after it stops being called for
  // N milliseconds. If `immediate` is passed, trigger the function on the
  // leading edge, instead of the trailing.
  debounce: function (func, wait, immediate) {
    var timeout;
    return function() {
      var context = this, args = arguments;
      var later = function() {
        timeout = null;
        if (!immediate) func.apply(context, args);
      };
      var callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) func.apply(context, args);
    };
  },

  isMobile: function () {
    if (window.innerWidth <= 1024) {
      return true
    } else {
      return false
    }
  },

  parallax_text: function ($selector, extra_top) {
    extra_top = typeof extra_top !== 'undefined' ? extra_top : 0;

    $(window).scroll(function() {
      var scroll = $(window).scrollTop(),
        slowScroll = scroll/1.4,
        slowBg = (extra_top + slowScroll) + "px",
        opacity,
        transform = "transform" in document.body.style ? "transform" : "-webkit-transform";;

      if (scroll > 0) {
        opacity = (1000 - (scroll*2.7)) / 1000;
      } else {
        opacity = 1;
      }

      $selector.css({
        "position": "relative",
        // transform: "translate3d(0, " + slowBg + ", 0)",
        top: slowBg,
        "opacity": opacity
      });
    });
  }
};
