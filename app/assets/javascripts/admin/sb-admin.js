$(function() {
  $('#side-menu').metisMenu();
  $('.checkable').change(function() {     //when an element of class checkable is clicked
    var check_count = $('.checkable:checked').size();  //count the number of checked elements
    if( check_count >= 1 ) {
      $("#bulk-edit-submit").prop("disabled", false)
    } else {
      $("#bulk-edit-submit").prop("disabled", true)
    }
  });
  $("#checkAll").click(function () {
    $('.checkable').not(this).prop('checked', this.checked);
    $('.checkable').trigger('change');
  });
});

//Loads the correct sidebar on window load,
//collapses the sidebar on window resize.
// Sets the min-height of #page-wrapper to window size
$(function() {
    $(window).bind("load resize", function() {
        topOffset = 50;
        width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
        if (width < 768) {
            $('div.navbar-collapse').addClass('collapse');
            topOffset = 100; // 2-row-menu
        } else {
            $('div.navbar-collapse').removeClass('collapse');
        }

        height = ((this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height) - 1;
        height = height - topOffset;
        if (height < 1) height = 1;
        if (height > topOffset) {
            $("#page-wrapper").css("min-height", (height) + "px");
        }
    });

    var url = window.location;
    var element = $('ul.nav a').filter(function() {
        return this.href == url || url.href.indexOf(this.href) == 0;
    }).addClass('active').parent().parent().addClass('in').parent();
    if (element.is('li')) {
        element.addClass('active');
    }
});

$(function() {
  return $('.chosen-select').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    width: '100%'
  });
});
