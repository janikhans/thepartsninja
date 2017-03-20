$(function () {
  navbar.initialize();

  retina.initialize();

  $('#sticky-sidebar').affix({
      offset: {
        top: 260
      }
  });

  var $body   = $(document.body);
  var navHeight = $('.navbar').outerHeight(true) + 10;

  $body.scrollspy({
    target: '#left-col',
    offset: navHeight
  });

});

var navbar = {
  initialize: function () {
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
  }
};

$(function() {
  return $('.chosen-select').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    width: '100%'
  });

  $('.collapse').on('show.bs.collapse', function () {
      $('.collapse.in').collapse('hide');
  });
});
